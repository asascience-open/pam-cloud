# Architecture of the PAMHUB System

## System Context

![System Context][pam-cloud-system-context]
![System Context Key][pam-cloud-system-context-key]

## Decompose PAMHUB into High level functions (Containers)

![Containers in PAMHUB][pam-cloud-containers]
![Containers in PAMHUB Key][pam-cloud-containers-key]

## Dagster Components

![Data pipelines in the Dagster service.][dagster-components]
![Dagster components key][dagster-components-key]

!!! NOTE 
    These diagrams follow the [C4 software diagramming](https://c4model.com) conventions.  Importantly, in these diagrams "Containers" are generic objects that "contain" functionality provided by software packages.  They are simply a level of abstraction that allows for showing different levels of detail in different diagrams.  THEY ARE NOT DOCKER CONTAINERS!

## Use Cases

Table of Use Cases

| Implementation Priority | UC ID | Use Case write up  | Related Issues |  UC Completion Status | 
|-------------------------|-------|--------------------|----------------|-----------------------|
| 1 | uc-012 | [Create project metadata](./uc-012-create-project-metadata.md) | NA | Incomplete |
| 1 | uc-011 | [QC check prior to data upload](./uc-011-pre-upload-integrity-check.md) | NA | Incomplete |
| 1 | uc-005 | [Upload raw audio](./uc-005-upload-raw-data-to-pamhub.md) | NA | Incomplete |
| 1 | uc-002 | [Create HMD files w PyPAM](./uc-002-create-hmd-files.md) | NA | Incomplete |
| 1 | uc-007 | [Quality control raw audio](./uc-007-quality-control-raw-audio.md) | NA | Incomplete |
| 1 | uc-001 | [Archive at NCEI](./uc-001-archive-pam-data-at-ncei.md) | NA | Incomplete |
| 1 | uc-013 | [QC HMD files](./uc-013-quality-control-HMD.md) | NA | Incomplete |
| 2 | uc-004 | [Visualize climatology](./uc-004-visualize-climatology.md) | NA | Incomplete |
| 3 | uc-003 | [Apply species detectors](./uc-003-detect-species-presence.md) | NA | Incomplete |
| 3 | uc-009 | [Integrate internal SoundScope visualization](./uc-009-soundscope-integration.md) | NA | Incomplete |
| 3 | uc-014 | [Archive HMD files at NCEI](./uc-014-archive-HMD-at-NCEI.md) | NA | Incomplete |
| 4 | uc-006 | [Visualize other](./uc-006-visualizations-other.md) | NA| On hold |
| 4 | uc-008 | [Publish detections to PACM and/or NCEI](./uc-008-publish-detections.md) | NA | Incomplete |
| 4 | uc-010 | [Provide analysis environment to external PIs/Data providers](./uc-010-external-investigator-analysis.md) | NA | Incomplete |


Data flow diagrams or other dynamic diagrams describing the use cases PAMHUB will address.

## Complete List of Detectors to be supported
See also [Issue 4](https://github.com/asascience-open/pam-cloud/issues/4)

**General Tools:**
- PAMGuard detectors: (included with the PAMGuard install)

**Multispecies Baleen Whales:**
- LFDCS

**North Atlantic Minke whale pulse-train detector:**

- CNN-based detector for detecting pulse trains from N-A minke whale. It is has been used along the US east coast from the Gulf of Maine , down to the Caribbeans and Mexico. It has mostly been used on fixed mooring, but a student from USVI used it successfully on glider data.
- The version most people use is on the repo here: https://github.com/xaviermouy/minke-whale-detector. The repo includes a word document with documentation/instructions.
- There is also a linux version to help batch processing on the NEFSC containers they run locally (i.e. not on their cloud environment). It is the same thing as above but with a few more sh scripts and wrapers to facilitate queuing processing tasks, etc. This was very specific for NEFSC's needs, so using the version above may be more appropriate. Repo here: https://github.com/xaviermouy/minke-whale-detector_batch-processing_linux

**General fish detector:**

A generic fish sound detector
- GitHub repo here: https://github.com/xaviermouy/FishSound_Finder
- Documentation and tutorial here: https://fishsound-finder.readthedocs.io/en/latest/

**Kurtosis detector:**

- This is a versatile impulse detector that is being used for detecting pile driving sounds (used by NOAA in the SNE wind energy areas for monitoring pile driving activity), haddock knock trains (what I use for monitoring haddock in the Gulf of Maine), and Megaptcliks from humpback whales (what I used in our herring investigation in Stellwagen bank).
- The configuration file used with the detector dictates what signals/frequencies to look for
- The GitHub repo is here and has a Word doc with instructions to run it: https://github.com/xaviermouy/KurtosisDetector

**Humpback detector:**

- This  is the package from Vincent Kather called AcoDet: https://github.com/vskode/acodet
- NOAA NEFSC is now using this detector in addition to LFDCS for humpbacks

## Architecture Decision Records

ADR [Table of Contents](adr-decisions.md)


---
[pam-cloud-system-context]: images/c4-system-context.svg
[pam-cloud-system-context-key]: images/c4-system-context-key.svg
[pam-cloud-containers]: images/c4-containers.svg
[pam-cloud-containers-key]: images/c4-containers-key.svg
[dagster-components]: images/c4-component-dagster.svg
[dagster-components-key]: images/c4-component-dagster-key.svg