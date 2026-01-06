# User Story 3: Process LFDCS and upload to NCEI and Makara/PACM  
## Description 

Here it is assumed that the data provider already has performed the data QA/QC with IOOS and that the raw data are already uploaded to the public NCEI repository / data bucket. 

This workflow processes raw acoustic data with the LFDCS detector to find low frequency whale calls (this is what most people use for NARW detections on the east coast). Outputs from the detector need to be manually verified by an analyst using a custom LFDCS GUI app. Reviewed detections (typically daily summaries) are summarized on a csv file that can be packaged to be sent to Makara (and can be displayed on Makara) and NCEI.

This process is now being done on (virtual) desktop machines in the cloud but NOAA is working on doing this implemented in Google Compose (not finished yet). 

The analysis protocol that NOAA and partners are using for LFDCS analysis is detailed in the report below. Note that some sections are not fully up to date now that NOAA has a compiled version of LFDCS that can work without the full IDL license and can work on WIndows and Mac and Linux. [https://dcs.whoi.edu/resources/LFDCS%20Reference%20Guide%20-%20Version%201.3.pdf](https://dcs.whoi.edu/resources/LFDCS%20Reference%20Guide%20-%20Version%201.3.pdf) 

## Requirements

- LFDCS is written in IDL. The application has been compiled so a full version of IDL is not required, but an IDL Runtime is still needed (cost \~$500)  
- Need to get the latest version of the LFDCS apps from NOAA (zip file)


## Workflow

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
