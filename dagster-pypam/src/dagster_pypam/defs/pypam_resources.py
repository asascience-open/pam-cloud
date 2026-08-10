import dagster as dg
from typing import Annotated, Literal, Union
from datetime import datetime
from pydantic import BaseModel, Field

class Coordinate(dg.Config):
    x: int
    y: int
class LatLonCoordinate(dg.Config):
    lat: float
    lon: float
    
class Recorder(dg.Config):
    generator: str

    def generate_metadata(self, log, uri, json_base_dir, prefixes,start,end) -> None:
        raise NotImplementedError

class SoundTrapRecorder(Recorder):
    generator: Literal['SOUNDTRAP'] = 'SOUNDTRAP'
    
    def generate_metadata(self, log, uri, json_base_dir, prefixes,start,end):
        from pbp.meta_gen.gen_soundtrap import SoundTrapMetadataGenerator
        #
        generator = SoundTrapMetadataGenerator(
                    log=log,
                    uri=uri,
                    json_base_dir=json_base_dir,
                    prefixes=prefixes,
                    start=start,
                    end=end,
         )
        generator.run()
        
class ReseaRecorder(Recorder):
    generator: Literal['RESEA'] = 'RESEA'
    
    def generate_metadata(self, log, uri, json_base_dir, prefixes,start,end):
        from pbp.meta_gen.gen_resea import ReseaMetadataGenerator
        #
  
        generator = ReseaMetadataGenerator(
                log=log,
                uri=uri,
                json_base_dir=json_base_dir,
                prefixes=prefixes,
                start=start,
                end=end,
            )
        generator.run()
    
class NRSRecorder(Recorder):
    generator: Literal['NRS'] ='NRS'
    
    
    def generate_metadata(self, log, uri, json_base_dir, prefixes,start,end):
        from pbp.meta_gen.gen_nrs import NRSMetadataGenerator

        generator = NRSMetadataGenerator(
                log=log,
                uri=uri,
                json_base_dir=json_base_dir,
                prefixes=prefixes,
                start=start,
                end=end,
            )
        generator.run()
    
class ICListenRecorder(Recorder):
    generator: Literal['ICLISTEN'] = 'ICLISTEN'
    
    
    def generate_metadata(self, log, uri, json_base_dir, prefixes,start,end):
        from pbp.meta_gen.gen_iclisten import IcListenMetadataGenerator
        
        generator = IcListenMetadataGenerator(
                        log=log,
                        uri=uri,
                        json_base_dir=json_base_dir,
                        prefixes=prefixes,
                        start=start,
                        end=end,
                    )
        generator.run()

    
class PyPamConfig(dg.ConfigurableResource):
    project:str
    deployment:str
    start_date: str
    end_date: str
    json_base_dir: str
    global_attrs_uri: str
    variable_attrs_uri: str

    raw_data: str
    output_dir: str
    output_prefix: str
    prefix: [str]
    voltage_multiplier: float =  None
    sensitivity_uri: str = None  
    sensitivity_flat_value: float
    
    compress_netcdf: bool = True
    add_quality_flag: bool = False
    exclude_tone_calibration_seconds: int = 0
    max_segments: int = 0
    
    subset_to:  dg.ResourceDependency[Coordinate]
    cmlim:  dg.ResourceDependency[Coordinate]
    ylim:  dg.ResourceDependency[Coordinate]
    latlon:  dg.ResourceDependency[LatLonCoordinate]
    
    recorder_type: Annotated[Union[
            SoundTrapRecorder,
            ReseaRecorder,
            NRSRecorder,
            ICListenRecorder,
        ],
        Field(discriminator="generator"),]
    



    def get_start_dt(self):
        return datetime.strptime(self.start_date, "%Y%m%d")
    
    def get_end_dt(self):
        return datetime.strptime(self.end_date, "%Y%m%d")

