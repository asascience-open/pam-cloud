import dagster as dg
import os
import xarray
import json
from pathlib import Path
from pbp.hmb_gen.process_helper import ProcessHelper, ProcessDayResult
from pbp.hmb_gen.file_helper import FileHelper
from pbp.hmb_plot.plotting import plot_dataset_summary
from pbp.util.logging_helper import create_logger
import pandas as pd
from datetime import date
from .pypam_resources import PyPamConfig
from pbp.meta_gen.gen_abstract import  MetadataGeneratorAbstract, SoundTrapMetadataGeneratorAbstract
import shutil
import datetime
import s3fs
from dagster_graphql.schema import auto_materialize_policy

def defs_for_dataset(pypam_dataset: PyPamConfig) -> dg.Definitions:


    daily_partitions = dg.DailyPartitionsDefinition(
            start_date=pypam_dataset.start_date,
            end_date=pypam_dataset.end_date,
            end_offset=1,
            fmt="%Y%m%d",
    )
    

    
    @dg.asset(name=f"{pypam_dataset.deployment}_generatejson_metadata")
    def generate_json_metadata(context: dg.AssetExecutionContext) -> None: 
        context.log.info(f"Generate JSON metadata for {pypam_dataset.project}/{pypam_dataset.deployment}")
        context.log.info(f"Recorder type: {pypam_dataset.recorder_type.generator}")
        
        log_filename = f"{pypam_dataset.output_dir}/{pypam_dataset.output_prefix}_json_metadata.log"

        t_logger = create_logger(
            log_filename_and_level=(log_filename, "INFO"),
            console_level=None,
        )
 
   
        #
        json_dir = Path(pypam_dataset.json_base_dir)
        
        json_dir.mkdir(exist_ok=True, parents=True)
        
        pypam_dataset.recorder_type.generate_metadata(log=t_logger,
                    uri=pypam_dataset.raw_data,
                    json_base_dir=json_dir.as_posix(),
                    prefixes=pypam_dataset.prefix,
                    start=pypam_dataset.get_start_dt(),
                    end=pypam_dataset.get_end_dt(),)

        context.add_output_metadata({
            "path": json_dir,
            })


    @dg.asset(
        partitions_def=daily_partitions,
        deps=[generate_json_metadata],
        name=f"{pypam_dataset.deployment}_process_date"
    )
    def process_date(context: dg.AssetExecutionContext) -> None: 
        """
        Main function to generate the HMB product for a given day.
    
        It makes use of supporting elements in PBP in terms of logging,
        file handling, and PyPAM based HMB generation.
    

    
        :return: the generated xarray dataset.
        """
        context.log.info(f"partition_date {context.partition_key}")
        process_date_str = context.partition_key
        
        context.log.info(f"process_date {process_date_str}")
        context.log.info(f"JSON base dir: {pypam_dataset.json_base_dir}")
        context.log.info(f"Global attributes: {pypam_dataset.global_attrs_uri}")
        context.log.info(f"variable attributes:{pypam_dataset.variable_attrs_uri} ")
        context.log.info(f"raw data: {pypam_dataset.raw_data}")
        context.log.info(f"output_dir: {pypam_dataset.output_dir} - prefix: {pypam_dataset.output_prefix}")
         
        context.log.info(f"sensitivity_uri {pypam_dataset.sensitivity_uri}")
        context.log.info(f"sensitivity_flat_value {pypam_dataset.sensitivity_flat_value}")
        context.log.info(f"voltage_mult {pypam_dataset.voltage_multiplier}")
        context.log.info(f"subset_t {pypam_dataset.subset_to}")
     
        log_filename = f"{pypam_dataset.output_dir}/{pypam_dataset.output_prefix}{process_date_str}.log"

      
        t_logger = create_logger(
            log_filename_and_level=(log_filename, "INFO"),
            console_level=None,
        )
        #t_logger = dg.get_dagster_logger()
        context.log.info(f"download dir: {pypam_dataset.raw_data}")
        context.log.info(f"json: {pypam_dataset.json_base_dir}")
       
    
        file_helper = FileHelper(t_logger,
                                 audio_base_dir=pypam_dataset.raw_data,
            json_base_dir=pypam_dataset.json_base_dir,
            download_dir=pypam_dataset.raw_data,
            assume_downloaded_files=True,
        )
        temp_directory ="./"
        context.log.info(f"Output dir1:{pypam_dataset.output_dir}")
        process_helper = ProcessHelper(t_logger,
            file_helper=file_helper,
            output_dir=temp_directory,#pypam_dataset.output_dir,
            output_prefix=pypam_dataset.output_prefix,
            
     
            compress_netcdf = pypam_dataset.compress_netcdf,
            add_quality_flag = pypam_dataset.add_quality_flag,
            exclude_tone_calibration_seconds = pypam_dataset.exclude_tone_calibration_seconds,
            max_segments = pypam_dataset.max_segments,
 
            global_attrs_uri=pypam_dataset.global_attrs_uri,
            variable_attrs_uri=pypam_dataset.variable_attrs_uri,
            voltage_multiplier=pypam_dataset.voltage_multiplier,
            sensitivity_uri=pypam_dataset.sensitivity_uri,
            subset_to=(pypam_dataset.subset_to.x,pypam_dataset.subset_to.y),
            sensitivity_flat_value=pypam_dataset.sensitivity_flat_value,
        )
        ## now, get the HMB result:
        context.log.info(f'::: Started processing {process_date_str}')
        result = process_helper.process_day(process_date_str)
        
        
        context.log.info(f"Output files:{result.generated_filenames}")
        context.log.info(f"Output dir2:{pypam_dataset.output_dir}")
        updated_paths =[]
        for local_f in result.generated_filenames:
            s3_loc = f"{pypam_dataset.output_dir}{local_f.split(temp_directory)[-1]}"
            context.log.info(f"Copy {local_f} to {s3_loc}")
            shutil.copyfile(local_f, s3_loc)
            os.remove(local_f)
            updated_paths.append(s3_loc)
            context.add_output_metadata({
                "nc_files": s3_loc,
            })
        context.log.info(f"updated_paths: {updated_paths}")


    @dg.asset(
        partitions_def=daily_partitions,
        name= f"{pypam_dataset.deployment}_generate_plot",
        deps=[process_date],
    )
    def generate_plot(context: dg.AssetExecutionContext,
                      ) -> None:
        
        pd.plotting.deregister_matplotlib_converters()
        context.log.info(f"Generate plot for {pypam_dataset.project}/{pypam_dataset.deployment}")
        nc_filename  = f"{pypam_dataset.output_dir}/{pypam_dataset.output_prefix}{context.partition_key}.nc"
 
        context.log.info(f':::   Processed {context.partition_key} =>  {nc_filename=}')
    
        jpeg_filename =  nc_filename.replace(".nc", ".jpg")
            
        with xarray.open_dataset(nc_filename, engine="h5netcdf") as ds:
                cmlim =(pypam_dataset.cmlim.x,pypam_dataset.cmlim.y)
                vmin, vmax = cmlim
                context.log.info(f'cmlim {cmlim} , vmin {vmin}, vmax {vmax}')
                context.log.info(f'ds time {ds.time}, {ds.frequency}')
                context.log.info(f'{ds}')
                context.log.info(f'{(pypam_dataset.latlon.lat,pypam_dataset.latlon.lon)}')
                context.log.info(f'{(pypam_dataset.ylim.x,pypam_dataset.ylim.y)}')
                context.log.info(f'{cmlim}')
                context.log.info(f'{jpeg_filename}')
                context.log.info(f'{ds.time}')
                plot_dataset_summary(
                    ds,
                    lat_lon_for_solpos=(pypam_dataset.latlon.lat,pypam_dataset.latlon.lon),
                    ylim=(pypam_dataset.ylim.x,pypam_dataset.ylim.y),
                    cmlim=cmlim,
                    jpeg_filename=jpeg_filename,
                    show=False,
                )
                context.log.info(jpeg_filename)
        context.add_output_metadata({
            "path": jpeg_filename,
            })


    
    metadata_job = dg.define_asset_job(
        f"generate_metadata_{pypam_dataset.deployment}",
        metadata={"project":pypam_dataset.project},
        selection=[generate_json_metadata],
    )
    
    pypam_job = dg.define_asset_job(
        f"process_date_{pypam_dataset.deployment}",
        metadata={"project":pypam_dataset.project},
        selection=[process_date],    
    )
    
    gen_plot_job = dg.define_asset_job(
        f"generate_plot_{pypam_dataset.deployment}",
        metadata={"project":pypam_dataset.project},
        selection=[generate_plot],
    )
  
        
    dataset_assets = [process_date, generate_plot,generate_json_metadata]
    dataset_jobs = [metadata_job,pypam_job,gen_plot_job]

   
    return dg.Definitions(
        assets=dataset_assets,
        jobs=dataset_jobs,
       
)
    