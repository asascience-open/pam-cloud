IOOS PAM Cloud stories

X. Mouy  
2025-10-07

1. **Scope of this document**


This document defines the different workflows (stories) that the PAM cloud infrastructure will be used for.  This is meant to describe the different components involved in the process and help identify parts of the process that need to be worked on.

2. **Story 1: Upload raw PAM data to NCEI**  
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
   2. If data size is too large to transfer via internet, the data provider will ship hard drives to Google via the T[ransfer Appliance service](https://cloud.google.com/transfer-appliance/docs/4.0/overview).  
8. IOOS analyst connects to the IOOS cloud workstation and starts the QA/QC process. This consists of 1\) running R and python routines to detect times and frequency bands of the data that may have issues (e.g. noise, data gaps, etc) and 2\) manually verifying a portion of the data that were flagged by the scripts. If the data uploaded by the data provider are compressed (e.g. sud file), IOOS will first need to decompress the data (e.g. using the SoundTrap software)  
9. IOOS analyst creates a QA/QC report and uploads it to the temporary data bucket for the data provider to review.  
10. Data provider uses temporary cloud workstation to access the QA/QC report and to verify a section of the data flagged using standard (e.g. Raven) and custom (e.g. possibly R/python GUI) software.  
11. Once the data provider approves the QA/QC report. IOOS proceeds with the data clearance process with the Navy. If the Navy requests the data to be scrutinized, they will be given access to the temporary NCEI data bucket to download and scrutinize the data. Data deemed problematic will be redacted and the NCEI data packaging process can start.   
12. IOOS uses BigQuery to query Makara and get all the metadata required to package the data to NCEI. IOOS uses PACE/Passive packer to package the data in a way that NCEI’s team can use. IOOS uses custom python script to include QC masks to the data package for easier integration to NCEI’s repository. All NCEI-ready data are placed on the NCEI data bucket.  
13. NCEI downloads data from the NCEI data bucket and integrates it to the the PAD  
14. Data from the data provider are publicly available on the NCEI PAD Google bucket ([https://console.cloud.google.com/storage/browser/noaa-passive-bioacoustic](https://console.cloud.google.com/storage/browser/noaa-passive-bioacoustic)) and discoverable on the NCEI Passive Acoustic Data Map ([https://www.ncei.noaa.gov/maps/passive-acoustic-data](https://www.ncei.noaa.gov/maps/passive-acoustic-data))  
15. If the data provider is not interested in pursuing more data analysis, IOOS terminates the data provider’s temporary cloud data bucket and the cloud workstation.  
      
3. **Story 2: Process hybrid milli-decades (HMD) and upload to NCEI**  
   1. *Description*: 

Here it is assumed that the data provider already has performed the data QA/QC with IOOS and that the raw data are already uploaded to the public NCEI repository / data bucket. 

2. *Workflow* 

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
      
4. **Story 3: Process LFDCS and upload to NCEI and Makara/PACM**  
   1. *Description*: 

   Here it is assumed that the data provider already has performed the data QA/QC with IOOS and that the raw data are already uploaded to the public NCEI repository / data bucket. 

   This workflow processes raw acoustic data with the LFDCS detector to find low frequency whale calls (this is what most people use for NARW detections on the east coast). Outputs from the detector need to be manually verified by an analyst using a custom LFDCS GUI app. Reviewed detections (typically daily summaries) are summarized on a csv file that can be packaged to be sent to Makara (and can be displayed on Makara) and NCEI.

   This process is now being done on (virtual) desktop machines in the cloud but NOAA is working on doing this implemented in Google Compose (not finished yet). 

   The analysis protocol that NOAA and partners are using for LFDCS analysis is detailed in the report below. Note that some sections are not fully up to date now that NOAA has a compiled version of LFDCS that can work without the full IDL license and can work on WIndows and Mac and Linux. [https://dcs.whoi.edu/resources/LFDCS%20Reference%20Guide%20-%20Version%201.3.pdf](https://dcs.whoi.edu/resources/LFDCS%20Reference%20Guide%20-%20Version%201.3.pdf) 

   2. *Requirements*

- LFDCS is written in IDL. The application has been compiled so a full version of IDL is not required, but an IDL Runtime is still needed (cost \~$500)  
- Need to get the latest version of the LFDCS apps from NOAA (zip file)


  3. *Workflow*

1. Data provider has already been through the QA/QC process through IOOS, **has metadata entered in Makara already**, and has raw PAM data available on the NCEI public repository (option 1\) or on a temporary data provider data bucket (option 2\)   
2. If option 1, IOOS creates a temporary data bucket and cloud workstation of the data provider. If option 2, the data provider will already have access to a cloud workstation and data bucket.  
3. IOOS analyst creates parameter files for each deployment to be processed by LFDCS. It involves a custom python script that queries Makara with BigQuery and automatically creates the text files.  
   ![][image3]  
4. Run LFDCS detector  
   Scenario 1: processing from the cloud workstation:  
   IOOS analyst connects to the cloud workstation, launches the LFDCS App Launcher, selects the “PROCESS: Reformat, Detect, and Classify” program, then select the parameter file of the deployment to process.  
   ![][image4]

   Scenario 2: processing with Google Compose (not implemented yet):

   IOOS analyst uploads txt files to a dedicated LFDCS data bucket and starts the processing by triggering the LFDCS process on Google Cloud Composer (Airflow interface). Several deployments can be processed at once. For option 1, the processing will be done using raw data from the NCEI data bucket. For option 2, the data processing will be done using raw data from the temporary data provider bucket.

5. IOOS manually verifies that the netcdf files from LFDCS have been created.  
6. Manual verification:  
   1. IOOS analyst connects to the cloud workstation, launches the LFDCS App Launcher  
   2. Analyst creates summary spreadsheet using the “EXPORT: convert netcdf to csv”  
   3. Analyst start the manual review process using the “REVIEW: Browse autodetections” app.   
      ![][image5]  
   4. Analyst go through detections and confirms daily/hourly presence  
   5. Analyst captures analysis results using the csv spreadsheet created in 6.b.  
      ![][image6]

      

7. Once the manual analysis is finished, the analyst run an R script to convert the csv spreadsheet into a format that is accepted by Makara. Analyst submits the packaged detections to the Makara portal.  
8. Detections are automatically  displayed on the PACM web interface (if the data owner has agreed to do so).  
9. Analyst coordinate with NCEI to send detections to NCEI via PACE, Passive Packer, or TugBoat.  
10. Detection data product from the data provider are publicly available on the NCEI PAD Google bucket ([https://console.cloud.google.com/storage/browser/noaa-passive-bioacoustic](https://console.cloud.google.com/storage/browser/noaa-passive-bioacoustic)) and discoverable on the NCEI Passive Acoustic Data Map ([https://www.ncei.noaa.gov/maps/passive-acoustic-data](https://www.ncei.noaa.gov/maps/passive-acoustic-data))  
    1. If the data provider is not interested in pursuing more data analysis, IOOS terminates the data provider’s temporary cloud data bucket and the cloud workstation.

5. **Story 4: NERACOOS to provide data visualization of data (products) available on NCEI**  
- This one will likely require intermediate data products stored at IOOS. Need to brainstorm about what visualization we want first, then define the backend that will be required.

  * NOTE: The current infrastructure developed by Tetra Tech/Axiom through the SoundCOOP project is one possible visualization tool.  Currently, it is designed for visualizing the HMD files.  Any modifications to that core function would need to be scoped out.
