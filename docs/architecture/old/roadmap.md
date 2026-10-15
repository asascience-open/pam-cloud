# High Level PAMHUB Roadmap 

This document describes the high level roadmap for PAMHUB development and lists the use cases that will be supported.  Day to day project management will utilize Github Issues, Milestones, and Projects.

## Assumptions

The following assumptions inform the milestone plan below.  They will be revisited periodically and if they change, the milestone plan will be uploaded accordingly.

- The windows workstation is required for initial development of the quality control procedures and the archiving pipeline.  But, the long term goal is to have the entire workflow ported to Python packages accessible via the JupyterHub environment.
- MVP will be the focus of the initial development between June-Dec 2026.  Refinements and improvements will be captured during this phase but not implemented until after Jan 2027.  


## Discovery and Design (COMPLETE IN GITHUB)

Ensure use cases are fully understood by the team and sequenced by priority and dependencies.  Identify any outstanding information we need for subsequent stages.

- See Github [milestone 1](https://github.com/asascience-open/pam-cloud/milestone/1)

## Customer Outreach (COMPLETE IN GITHUB)

NERACOOS Priority 1

DESCRIPTION

- Obtain 5 test datasets from providers : crit, se1, 2026-01-06, 2026-12-31
- Define soundscape metrics 
- GMRI transition planning           : active, se5, 2026-01-06, 2026-12-31

## Data ingest infrastructure (COMPLETE IN GITHUB)

NERACOOS Priority 1

Several (3-5?) data sets uploaded to the cloud and documentation has been written explaining the upload process and identifying any challenges experienced during the intial phase.  Basic metadata creation tool is complete and the metadata is manually entered into the system through a web form and is loaded into the database.  Basic pre-upload QC implemented, possibly as a client side script. Refinements to tools are recorded for future releases.

- uc-012 create project metadata
- uc-011 pre-upload integrity checks
- uc-005 upload raw data

- Create project metadata (P1) : active, uc-012, 2026-06-01, 2026-12-31 IN GITHUB #21
- Pre-upload QC (P1) : active, uc-011, 2026-06-01, 2026-12-31 IN GITHUB #20
- Upload raw audio (P1) : active, uc-005, after uc-011, 2026-12-31 IN GITHUB #24
- Create pam-ww Windows workstation (P1)    : active, pam-ww, after dd2, 30d IN GITHUB #, MOVED TO DESIGN MILESTONE

## Audio file pre-processing. (COMPLETE IN GITHUB, MOVED TO "Data Ingest Infrasstructure")

NERACOOS Priority 1

Prior to calculation of HMD, quality control procedures of raw audio files is done via manual data analysis in the cloud environment (e.g. windows workstation running Raven or other audio file analysis).  Data preparation tasks are complete (e.g. format conversion from \*.wav to \*.flac etc.).

- uc-007

## HMD Creation (COMPLETE IN GITHUB)

NERACOOS Priority 1

HMD files are created using the Dagster PyPAM/PBP pipeline.  Quality control is performed on HMD files.  Role of PI vs PAM Analyst is clarified wrt QC of HMD Output. 

- Create Wellfleet HMD (P1) : active, well-hmd, 2026-06-01, 30d 
- uc-002 Create HMD files (P1)     (IN GITHUB)
- QC Wellfleet HMD (P1)  : well-hmd-qc, after well-hmd, 15d
- uc-013 QC HMD files     (P1)  : uc-013, 2026-06-01, 2026-12-31 (IN GITHUB)

## NCEI Archiving (COMPLETE IN GITHUB)

NERACOOS Priority 1 and Priority 3

NNN raw audio data sets, including the WellFleet dataset, have been moved through the archive process manually by the PAM Analyst.  Required software tools are installed on the windows workstation and, where applicable, in the JupyterHub.  POC for each archive process is established and the metadata requirements are documented and reconciled with the metadata entry tool and any other configuration metadata needed for product development. Relationship between archiving raw audio vs archiving HMD files is clearly documented (e.g. one package or two?)

- uc-001 (P1)
- uc-014 (P3)

Archive Wellfleet dataset (P1) : active, wellfleet-archive, after pam-ww, 2026-09-30
Archive N raw audio datasets (P1) : uc-001, 2026-08-01, 2026-08-30
Archive M HMD datasets (P1)  : uc-014, 2026-02-01, 2026-08-30


## Species detection (COMPLETE IN GITHUB)

NERACOOS Priority 3

LFDCS detection pipeline is developed and applied to test data sets (MVP). Other species detectors are incorporated into the pipeline following user priorization (post-MVP). Python framework for plug and play species detectors is scoped and level of effort is determined.  Governance of species detection approvals is documented and the implementation of approval tools is tested with one or more PI's.

- uc-003 (NO ISSUE, superceded by specific Issues identifying the exact detector to use.)
- Develop modular detector framework. (ISSUE CREATED)
- uc-009 Integrate internal SoundScope visualization. (ISSUE CREATED)
- LFDCS Workflow (P2) (ISSUE CREATED)
- Output PACM files for PI (P4)  (ISSUE CREATED, labeled wontfix)

## Climatology Visualization (COMPLETE IN GITHUB)

NERACOOS Priority 2

DESCRIPTION

- uc-004 Define climatology visualization (P2) 
- Deliver climatology metrics code (P2) : milestone, clim-code, 2026-07-01, 0d
- Prototype climatology visualization (P2): crit, after clim-code, 30d 
- Climatology creation pipeline (P2) : active, uc-004, after clim-proto, 30d 
- Create draft visualization website : v1, after uc-004, 30d
- Determine website host : milestone, m2, 2026-06-05, 0d
- Deploy visualization to host      : v3, after v1, 60d

Need better detail on the Sanctuaries product development software.  How exactly do we need to replicate the Sanctuaries plots? https://www.soundscapemonitoring.us/content/index.html
Brian described the backend database that powers several visualizations.  It should be compared to the Sanctuaries plots.  
See this presentation for links to R code that creates the Soundscapes visualizations.
Minor discrepancy.  In one place in the presentation they refer to this R Code as Pamverse and in another place it’s PAMScapes.  The only thing I can find on Github is PAMScapes so I assume that’s correct.  

PAMScapes vs PAMVerse?
https://github.com/TaikiSan21/PAMscapes/tree/main


## Enahnced analysis and reporting (COMPLETE IN GITHUB)

NERACOOS Priority 4

DESCRIPTION

- uc-006 Other visualizations
- uc-008 Publish detections to PACM 
- uc-010 Provide analysis environment to external PIs/Data Providers (IN GITHUB #29)

## Transition and Reporting (COMPLETE IN GITHUB)

NERACOOS Priority 4

- Documentation         :  2025-08-06, 2026-08-30 (IN GITHUB)
- Training         : u1, 2025-08-06,2026-08-30 
- Determine long-term analyst role  : t1, 2026-10-01, 2027-06-30
- Transition PAMHUB portal to GMRI  : t2, after v3, 60d 
- Transition Cloud Infrastructure to host : t3, after s3, 30d
- Develop cost tracking dashboard     :  cost, 2026-07-01, 30d (IN GITHUB)
