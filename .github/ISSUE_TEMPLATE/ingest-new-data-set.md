---
name: Ingest and process a new data set
about: Capture the details of a new PAM data set to upload into PAMHUB for processing.
title: "Process XYZ dataset"
labels: ''
assignees: ''

---

**Dataset Name:**
**Data Provider (email or GH handle):**
**Approximate dataset size (Gb)( _Ballpark size is sufficient for planning purposes_):**
**Project Description (Short abstract describing when/where/how the dataset was collected.  Identify target species if known):**

Processing checklist (used to create sub-issues):

- [ ] Upload DATASETNAME data to S3 bucket
- [ ] Create and standardize project/deployment/platform metadata for DATASETNAME
- [ ] Create HMD for DATASETNAME dataset
- [ ] QC HMD files for DATASETNAME dataset
- [ ] Extract soundscape metrics from DATASETNAME HMD files
- [ ] Create soundscape plots from DATASETNAME extracts
- [ ] Apply species detectors to DATASETNAME dataset
- [ ] Archive raw audio data DATASETNAME
- [ ] Archive HMD files from DATASETNAME