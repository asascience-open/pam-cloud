# Use Case: Upload Raw PAM Data to NCEI

**ID:** UC-001
**Goal:** Submit a raw audio dataset and associated metadata for QA/QC and long-term archiving at NCEI

---

## 1. Descriptions

**Primary Actor:** PAM Data Provider
**Trigger:** A data provider has recovered PAM moorings, downloaded data from the recorders, and is ready to begin the archiving process.
**Pre-conditions:** TBD. What level of quality control is done before uploading anything?  Do we expect that PAMHUB receives only raw data or partially/completely processed data?  This is important to decide how many times a given data set might be uploaded to the PAMHUB.
**Post-conditions:** TBD
**Priority:** High

## 2. Basic Flow (Happy Path)

> **Note:** This section is pending completion. The basic flow will be derived from manual archiving interactions conducted by the PAM Analyst during the first increment. The PAM Analyst will document exact steps during live NCEI submissions, and those steps will inform this section.

Draft flow from original user stories.  

- Archive raw audio 
  - Create deployment metadata
  - Upload raw audio to cloud (large files via hard drive and small files via gsutils)
  - Quality control raw audio
  - Create raw audio archive package
  - Archive raw audio package at NCEI

## 3. Alternative / Exception Flows

### 3.1 Data volume too large for internet transfer

Includes, data volumes are too large and therefore egress fees are too expensive for cloud to cloud transfer.
> TBD

### 3.2 Navy review required before NCEI submission

> TBD

### 3.3 Other TBD failure

> TBD

## 4. Special Requirements

> TBD — Requirements will be captured by the PAM Analyst during manual NCEI archiving interactions in the first increment and passed to the development team for incorporation here.


## Prior User Story

1. Data provider recovers PAM moorings, downloads data from the recorders and performs data backup.	  
2. Data provider enters metadata of the deployment locations, instrument specifications and recording cycles to the NOAA Makara database using the Makara Data Portal interface ([https://passiveacoustics.fisheries.noaa.gov](https://passiveacoustics.fisheries.noaa.gov)). At this stage the data provider also defines data sharing permissions (PACM visibility, accessibility from other users, etc.).  
3. NOAA includes deployment location and metadata to the PACM website  
4. IOOS uses metadata from the data provider and coordinates with Navy to identify if the raw audio data need to be scrutinized by the Navy before being uploaded to NCEI.   
5. IOOS creates a temporary data bucket only accessible to the data provider and IOOS.  
6. IOOS creates a temporary virtual cloud Windows workstation for the data provider. The workstation has access to the temporary data bucket and has a [suite of acoustic analysis software](./external-software-dependencies.md) already installed such as Raven, R, python (Anaconda, PyCharm), SoundTrap software. Software requiring a license can be installed by the data provider (by coordinating with IOOS admin). The data provider will need its own license.
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

[dataflow-ncei]: images/Diagram_data-upload-NCEI_.png

---

*Status: Stub — intentionally incomplete. Do not begin implementation design against this document until Sections 2 and 3 are populated and the document is marked Ready for Review.*
