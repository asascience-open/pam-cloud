# Story 1: Upload raw PAM data to NCEI

1. *Description*: 

Here the data provider has collected PAM data and wants to have the data QA/QCd and have the data uploaded to the public NCEI repository. 


2. *Workflow* 

![][image1]

1. Data provider recovers PAM moorings, downloads data from the recorders and performs data backup.	  
2. Data provider enters metadata of the deployment locations, instrument specifications and recording cycles to the NOAA Makara database using the Makara Data Portal interface ([https://passiveacoustics.fisheries.noaa.gov](https://passiveacoustics.fisheries.noaa.gov)). At this stage the data provider also defines data sharing permissions (PACM visibility, accessibility from other users, etc.).  
3. NOAA includes deployment location and metadata to the PACM website  
4. IOOS uses metadata from the data provider and coordinates with Navy to identify if the raw audio data need to be scrutinized by the Navy before being uploaded to NCEI.   
5. IOOS creates a temporary data bucket only accessible to the data provider and IOOS.  
6. IOOS creates a temporary virtual cloud Windows workstation for the data provider. The workstation has access to the temporary data bucket and has a suite of acoustic analysis software already installed including Raven, R, python (Anaconda, PyCharm), SoundTrap software. Software requiring a license can be installed by the data provider (by coordinating with IOOS admin). The data provider will need its own license.   
7. Data provider uploads the raw passive acoustic data to the temporary data bucket.  
   1. If data size is manageable, the data provider will upload data via internet using the command line tool gsutil. Transferring compressed files (e.g. .sud files from SoundTrap recorders) should be preferred when available.  
   2. If data size is too large to transfer via internet, the data provider will ship hard drives to Google via the [Transfer Appliance service](https://cloud.google.com/transfer-appliance/docs/4.0/overview).  
8. IOOS analyst connects to the IOOS cloud workstation and starts the QA/QC process. This consists of 1\) running R and python routines to detect times and frequency bands of the data that may have issues (e.g. noise, data gaps, etc) and 2\) manually verifying a portion of the data that were flagged by the scripts. If the data uploaded by the data provider are compressed (e.g. sud file), IOOS will first need to decompress the data (e.g. using the SoundTrap software)  
9. IOOS analyst creates a QA/QC report and uploads it to the temporary data bucket for the data provider to review.  
10. Data provider uses temporary cloud workstation to access the QA/QC report and to verify a section of the data flagged using standard (e.g. Raven) and custom (e.g. possibly R/python GUI) software.  
11. Once the data provider approves the QA/QC report. IOOS proceeds with the data clearance process with the Navy. If the Navy requests the data to be scrutinized, they will be given access to the temporary NCEI data bucket to download and scrutinize the data. Data deemed problematic will be redacted and the NCEI data packaging process can start.   
12. IOOS uses BigQuery to query Makara and get all the metadata required to package the data to NCEI. IOOS uses PACE/Passive packer to package the data in a way that NCEI’s team can use. IOOS uses custom python script to include QC masks to the data package for easier integration to NCEI’s repository. All NCEI-ready data are placed on the NCEI data bucket.  
13. NCEI downloads data from the NCEI data bucket and integrates it to the the PAD  
14. Data from the data provider are publicly available on the NCEI PAD Google bucket ([https://console.cloud.google.com/storage/browser/noaa-passive-bioacoustic](https://console.cloud.google.com/storage/browser/noaa-passive-bioacoustic)) and discoverable on the NCEI Passive Acoustic Data Map ([https://www.ncei.noaa.gov/maps/passive-acoustic-data](https://www.ncei.noaa.gov/maps/passive-acoustic-data))  
15. If the data provider is not interested in pursuing more data analysis, IOOS terminates the data provider’s temporary cloud data bucket and the cloud workstation.

