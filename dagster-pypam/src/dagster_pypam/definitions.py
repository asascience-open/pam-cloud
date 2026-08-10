from pathlib import Path
import dagster as dg

from defs.pypam_resources import PyPamConfig, Coordinate, LatLonCoordinate
from defs.assets import   defs_for_dataset
import os
import json
from defs.pypam_resources import Recorder



@dg.definitions
def resources() -> dg.Definitions:
    
    config_dir = os.getenv("CONFIG_DIR")
    output_loc = os.getenv("OUTPUT_DIR")
    s3_path = os.getenv("INPUT_S3_PATH")
    mounted_path  = os.getenv("INPUT_MOUNTED_PATH")
    
    datasets = []
    for projects in os.listdir(config_dir):
        if not os.path.isdir(f"{config_dir}/{projects}"): continue
        proj_dir = f"{config_dir}/{projects}"
        
        for config_f in os.listdir(proj_dir):
            
            if config_f[-5:].lower() != ".json": continue
           
            
            with open(f"{proj_dir}/{config_f}", 'r') as proj_file:
                
                config = json.load(proj_file)
            
            
            deployment =  config["deployment"]
            project = config["project"]
            deployment_out = os.path.join(output_loc, project,deployment)
            json_base_dir=os.path.join(deployment_out,'json_output')
            output_dir =os.path.join(deployment_out,'output')
            # Fix s3 paths to the mounte drive
            raw_data =f"file://{config['raw_data'].replace(s3_path,mounted_path)}"
            variable_attrs_uri = f"{config['variable_attrs_uri'].replace(s3_path,mounted_path)}"
            global_attrs_uri = f"{config['global_attrs_uri'].replace(s3_path,mounted_path)}"
           
            optional_keys = ["compress_netcdf",
                            "add_quality_flag",
                            "exclude_tone_calibration_seconds",
                            "max_segments",
                            "voltage_multiplier",]
            optional_kwargs = {
                    key: config[key]
                    for key in optional_keys
                    if key in config
                }
      
            
            datasets.append(PyPamConfig(
                project =config['project'],
                deployment=config['deployment'],
                cmlim=Coordinate(x=config["cmlim_x"],y=config['cmlim_y']),
                global_attrs_uri=global_attrs_uri,
                json_base_dir=json_base_dir,
                latlon=LatLonCoordinate(lat=config["lat"], lon=config["lon"])    ,
                output_dir=output_dir,
                output_prefix=config["output_prefix"],
                start_date=config["start_date"],
                end_date=config["end_date"],
                raw_data=raw_data,
                sensitivity_flat_value=config["sensitivity_flat_value"],
                subset_to=Coordinate(x=config["subset_x"], y=config["subset_y"]),
                prefix=config["prefix"],
                variable_attrs_uri=variable_attrs_uri,
                ylim=Coordinate(x=config["ylim_x"], y=config["ylim_y"]),
                recorder_type=Recorder(generator=config['recorder_type']),
                **optional_kwargs                
                )
    )
            
        
    defs= dg.Definitions()
   

    for dataset in datasets:
        dataset_defs = defs_for_dataset(dataset)
        defs = dg.Definitions.merge(defs, dataset_defs)
    return defs
