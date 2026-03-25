# Use Case: Calculate Spectrograms

**ID:** UC-002
**Goal:** Run spectrogram calculations on a stored raw dataset using the PyPAM workflow and package results for NCEI submission

---

## 1. Descriptions

**Primary Actor:** PAM Analyst
**Trigger:** Raw PAM data and associated metadata are available in PAMHUB storage and the PAM Analyst initiates spectrogram processing for one or more deployments.
**Pre-conditions:** TBD — depends in part on metadata database design (see Decision 0 in `scope-reframe-2026.md`)
**Post-conditions:** TBD
**Priority:** High

## 2. Basic Flow (Happy Path)

> **Note:** This section is pending completion. A working PyPAM-based spectrogram workflow exists from a prior project and will serve as the starting point. The basic flow will be defined during first increment development as the workflow is integrated into the PAMHUB orchestration environment. The orchestration tool must be confirmed before this flow can be finalized.

- Create hybrid milli-decade (HMD) files and archive
  - Create deployment metadata
  - Upload raw audio to cloud
  - Quality control raw audio
  - Launch pam-ww cloud workstation
  - Process raw audio with PyPAM
    - Create PyPAM config yaml files for deployment
    - Trigger PyPAM processing
    - Quality control PyPAM output
  - Archive HMD output at NCEI
    - Create HMD archive package
    - Archive HMD package at NCEI

## 3. Alternative / Exception Flows

### 3.1 Processing fails for one or more deployments in a batch

> TBD

### 3.2 Output files fail QA/QC verification

> TBD

## 4. Special Requirements

> TBD — Known consideration: multiple deployments must be processable simultaneously. Performance and compute requirements will be informed by first increment integration work.

## Prior user story retained for editing or further analysis
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
---

*Status: Stub — intentionally incomplete. Do not begin implementation design against this document until Sections 2 and 3 are populated and the document is marked Ready for Review.*
