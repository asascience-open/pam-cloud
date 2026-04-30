# Architecture of the PAMHUB System

## System Context

![System Context][pam-cloud-system-context]
![System Context Key][pam-cloud-system-context-key]

## Containers within PAMHUB

![Containers in PAMHUB][pam-cloud-containers]
![Containers in PAMHUB Key][pam-cloud-containers-key]

## Dagster Components

![Data pipelines in the Dagster service.][dagster-components]
![Dagster components key][dagster-components-key]

!!! NOTE 
    These diagrams follow the [C4 software diagramming](https://c4model.com) conventions.  Importantly, in these diagrams "Containers" are generic objects that "contain" functionality provided by software packages.  They are simply a level of abstraction that allows for showing different levels of detail in different diagrams.  THEY ARE NOT DOCKER CONTAINERS!

## Use Cases

Table of Use Cases (Not necessarily in order of importance or in a logical development sequence.)

!!! NOTE 
    Original [User Stories](./PAM_Cloud_stories.docx.md).  
    This file is not maintained.  It has been decomposed into smaller stories or use cases below.

| UC ID | Use Case write up  | Related Issues |
|------|---------------------|----------------|
| uc-001 | [Archive at NCEI](./uc-001-archive-pam-data-at-ncei.md) | NA|
| uc-002 | [Calculate spectograms and write to HMD files w PyPAM](./uc-002-calculate-spectrograms.md) | NA|
| uc-003 | [Apply species detectors](./uc-003-detect-species-presence.md) | NA|
| uc-004 | [Visualize climatology](./uc-004-visualize-spectrogram-climatology.md) | NA|
| uc-005 | [Upload data](./uc-005-upload-raw-data-to-pamhub.md) | NA|
| uc-006 | [Visualize other](./uc-006-visualizations-other.md) | NA|
| uc-007 | [Quality control raw audio](./uc-007-quality-control-raw-audio.md) | NA|
| uc-008 | [Publish detections to PACM and/or NCEI](./uc-008-publish-detections.md) | NA |
| uc-009 | [Integrate internal SoundScope visualization](./uc-009-soundscope-integration.md) | NA |
| uc-010 | [Provide analysis environment to external PIs/Data providers](./uc-010-external-investigator-analysis.md) | NA |
| uc-011 | [QC check prior to data upload](./uc-011-pre-upload-integrity-check.md) | NA |

Other use cases we have/are considering:

1. Archive Spectograms/HMD files
2. Quality control raw data as an automated process
3. Archive detections
Data flow diagrams or other dynamic diagrams describing the use cases PAMHUB will address.

## Architecture Decision Records

ADR [Table of Contents](adr-decisions.md)


---
[pam-cloud-system-context]: images/c4-system-context.svg
[pam-cloud-system-context-key]: images/c4-system-context-key.svg
[pam-cloud-containers]: images/c4-containers.svg
[pam-cloud-containers-key]: images/c4-containers-key.svg
[dagster-components]: images/c4-component-dagster.svg
[dagster-components-key]: images/c4-component-dagster-key.svg