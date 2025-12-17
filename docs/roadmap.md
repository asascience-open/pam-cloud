# High Level PAMHUB Roadmap 

This document describes the high level roadmap for PAMHUB development and decomposes the initial known User Stories into smaller increments that will be used for more detailed project planning.  Day to day project management will utilize Github Issues, Milestones, and Projects.


```mermaid
gantt
    dateFormat  YYYY-MM-DD
    title       PAMHUB Migration
    excludes    weekends
    %% (`excludes` accepts specific dates in YYYY-MM-DD format, days of the week ("sunday") or "weekends", but not the word "weekdays".)

    section Discovery and Design
    Migrate static code                 :done,    dd1, 2025-08-06,2026-08-30
    Identify software dependencies      :active,  dd2, 2025-09-01, 2025-12-31
    Estimate storage needs              :active,  dd3, 2025-09-01, 2025-12-31
    Track costs                         :active,  cost, 2025-09-01, 2026-07-31

    section Stakeholder Engagement
    Obtain data from a : se1, 2026-01-06,7d
    Obtain data from b : se2, 2026-01-06,7d
    Obtain data from c : se3, 2026-01-06,7d
    Define visualization 2: se4, 2026-01-06, 2026-01-31
    ONR Programmatic Review                :milestone, 2026-01-14, 0d
    Regional Coordination Workshop.        : milestone, 2026-01-21, 0d
    GMRI Engagement.  : se5, 2026-03-01, 2026-07-31

    section MVP Manual Processing
    Create pam-ww workstation               :active, man1, after dd2, 30d
    Upload test data          : man2, after man1  , 10d
    Manual QC of raw audio    : man3, after man1  , 10d
    Process LFDCS detections  : man4, after man1, 20d
    Test N detectors.         : man5, after man4, 30d

    section Scaling and automation
    Design batch scaling orchestration             :after doc1, 30d
    Decide on Makara replacement      :milestone, 2026-01-30, 0d

    section Usability
    Document architecture         : u1, 2025-08-06,2026-08-30
    Document manual and batch operations. : 2025-08-06,2026-08-30

    section Interoperability
    Define NCEI archive process : 2025-08-06, 2026-08-30
    Develop metadata export package for archive : 2025-08-06, 2026-08-30
    Archive N datasets.  : 2025-08-06,2026-08-30
    Visualize on PACM.   : 2025-08-06,2026-08-30
    Determine website host : milestone, m2, 2026-01-05, 0d
    Deploy visualization to host.      : 2026-03-01, 2026-03-30

    section Contracting and Reporting
    End ONR Period of Performance.  : milestone, 2026-07-31,0d
    Development ends : vert, 2026-07-31

```

The envisioned Phases
- Phase 0 — (Discovery Phase) Requirements & design: map NOAA PAM-Cloud features to PAMHUB decisions.
- Phase 1 — MVP: ingest raw audio storage, manual quality control using cloud workstation (pam-ww) based detection processing, 
- Phase 2 — Scale & automation: batch scaling, queueing, operational maturity.
- Phase 3 — Usability: docs, onboarding workshops, example datasets for community use.
- Phase 4 — Interoperability: archival export templates and national compatibility.

Throughout the project there will be ongoing stakeholder engagement to identify new datasets for ingestion into the system and new products to be developed based on the PAMHUB data holdings.

- Stakeholder Outreach
  - [Data Providers](data-providers.md) 
  - Customers for derived products (see [User Story 004](us-004-visualizations) for initial product development goals.


- Develop Cloud Storage System
  - Upload small datasets
  - Upload large datasets
  - Upload metadata
  - Upload derived products
- Develop pam-ww cloud workstation 
  - Create windows based workstation
  - Install software dependencies
  - Negotiate licenses for software dependencies
- Develop batch scaling infrastructure
  - Decide on workflow orchetration architecture
  - Develop detector interface architecture (to support plug and play detectors in a workflow)
  - Create containers with dependencies
  - Reproduce manual workflows
- Create database infrastructure (if not Makara)
  - Collect requirements for each software dependency and NCEI
  - Create data model for each user story (or use case)
  - Determine metadata requirements for NCEI archiving
- Create derived products
  - Visualization system for HMD files
  - Visualization of HMD climatology

## User Stories 
References and decomposition into standalone tasks.  Original [User Stories](./PAM_Cloud_stories.docx.md).  NOTE: This file is not maintained.  It will be decomposed into smaller stories below and recorded as Issues.

### US-001 Archive raw audio at NCEI
Original reference: [User Story 001](us-001-archive-raw-audio.md)
- Archive raw audio 
  - Create deployment metadata
  - Upload raw audio to cloud (large files via hard drive and small files via gsutils)
  - Quality control raw audio
  - Create raw audio archive package
  - Archive raw audio package at NCEI

### US-002 Create hybrid milli-decade (HMD) files and archive
Original reference: [User Story 002](us-002-create-HMD-files.md)

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

## US-003 Create LFDCS Whale detections
Original reference: [User Story 003](us-003-lfdcs-whale-detections.md)

- Create LFDCS Whale detections, archive at NCEI, and publish to PACM 
  - Create deployment metdata
  - Upload raw audio to cloud
  - Quality control raw audio
  - Run LFDCS detector
    - Launch pam-ww cloud workstation
    - Create LFDCS config parameter file
    - Run LFDCS detector on pam-ww cloud workstation
  - Quality control LFDCS output
  - Create LFDCS archive package
  - Archive LFDCS archive package at NCEI
  - _Upload LFDCS detections to Makara and PACM (NOTE: To be verified)_

## US-004 Visualize HMD Climatology
[User Story 004](us-004-visualize-climatology)

 
From Jackie in Google Docs comments.  We'd like to start with a plotted climatology of HMD. This is helpful for observing variability and detecting anomalies, and it's also similar to our existing Climatology which we hope to integrate some of the data sets in the future. @xavier.mouy@whoi.edu has worked on this and has some code to share.


## US-005 Other Visualizations

Placeholder for additional derived products and visualizations to be defined through targetd stakeholder engagement.