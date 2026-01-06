# User Story 2: Process hybrid milli-decades (HMD) and upload to NCEI

## Description

Here it is assumed that the data provider already has performed the data QA/QC with IOOS and that the raw data are already uploaded to the public NCEI repository / data bucket. 

## Workflow

![][image2]

1. Data provider has already been through the QA/QC process through IOOS, has metadata entered in Makara and has raw PAM data available on the NCEI public repository (option 1 – solid red arrow in diagram above) or on a provide temporary data provider data bucket (option 2 – dashed red arrow in the diagram above)  
2. If option 1, IOOS creates a temporary data bucket and cloud workstation of the data provider. If option 2, the data provider will already have access to a cloud workstation and data bucket.  
3. IOOS analyst creates config files for each deployment to be processed by pypam. It involves a custom python script that queries Makara with BigQuery and automatically creates yaml files.  
4. IOOS analyst uploads yaml files to a dedicated pypam data bucket and starts the processing by triggering the pypam process on Google Cloud Composer (Airflow interface). Several deployments can be processed at once. For option 1, the processing will be done using raw data from the NCEI data bucket. For option 2, the data processing will be done using raw data from the temporary data provider bucket.  
5. IOOS manually verifies that all daily netcdf files have been created, performs QA/QC (scanning through daily Long Term Spectral Averages, etc), and places all results on the data provider temporary data bucket.  
6. Data provider uses temporary cloud workstation to verify HMD results  
7. IOOS packages netcdf files to NCEI format using PACE/Passive Packer, includes QA/QC mask, and uploads to temporary NCEI data bucket.  
8. NCEI downloads data from the NCEI data bucket and integrates it to the PAD repository  
9. HMD data product from the data provider are publicly available on the NCEI PAD Google bucket ([https://console.cloud.google.com/storage/browser/noaa-passive-bioacoustic](https://console.cloud.google.com/storage/browser/noaa-passive-bioacoustic)) and discoverable on the NCEI Passive Acoustic Data Map ([https://www.ncei.noaa.gov/maps/passive-acoustic-data](https://www.ncei.noaa.gov/maps/passive-acoustic-data))  
10. If the data provider is not interested in pursuing more data analysis, IOOS terminates the data provider’s temporary cloud data bucket and the cloud workstation.  
