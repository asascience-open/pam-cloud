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
    Obtain data from providers : se1, 2026-01-06,14d
    Define climatology visualization  : se4, 2026-01-06, 2026-01-31
    ONR Programmatic Review           :milestone, 2026-01-14, 0d
    Regional Coordination Workshop    : milestone, 2026-01-21, 0d
    GMRI Engagement           : se5, 2026-03-01, 2026-07-31
    Negotiate code/data sharing w NOAA  : se6, 2025-12-01, 2026-02-15

    section MVP Manual Processing
    Create pam-ww Windows workstation     :active, man1, after dd2, 30d
    Upload test data          : man2, after man1  , 10d
    Manual QC of raw audio    : man3, after man1  , 10d
    Manual derivation of HMD  : man6, after man1, 30d
    Process LFDCS detections  : man4, after man1, 20d
    Test N detectors.         : man5, after man4, 30d

    section Scaling and Automation
    Design batch scaling orchestration             :s1, after doc1, 30d
    Decide on Makara replacement      :milestone, 2026-01-30, 0d
    Test automation against manual products : s3, after s1, 30d
    Finalize batch-scaling    : s4, after s3, 30d

    section Usability
    Document architecture         : u1, 2025-08-06,2026-08-30
    Document manual and batch operations. : u2, 2025-02-06,2026-08-30
    Create training curriculum for users  : u3, 2026-02-06,2026-08-30

    section Visualization
    Create draft visualization website : v1, 2026-02-01, 2026-04-01
    Determine website host : milestone, m2, 2026-01-05, 0d
    Refine visualization website   : v2, after u3, 30d
    Deploy visualization to host      : v3, 2026-03-01, 2026-03-30

    section Interoperability
    Define NCEI archive process : i1, 2026-02-01, 30d
    Develop metadata export package for archive : i2, after i1, 30d
    Archive N datasets/derived products  : i3, 2026-02-01, 2026-08-30
    Visualize on PACM???   : 2026-04-01, 2026-08-30

    section Transition
    Determine long-term analyst role  : t1, 2026-04-01, 2026-06-30
    Transition PAMHUB portal to GMRI  : t2, after v3, 60d
    Transition Cloud Infrastructure to host : t3, after s3, 30d

    section Contracting and Reporting
    End ONR Period of Performance.  : milestone, 2026-07-31,0d
    Development ends : vert, 2026-07-31

```


TODO: Create a section below for each section in the Gantt chart.  Include more details of the work to be done in the Gantt section.  Elaborate with questions, decisions, uncertainties.

- Develop batch scaling infrastructure
  - Decide on workflow orchestration architecture
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