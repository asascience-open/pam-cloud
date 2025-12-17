# PAMHUB — NERACOOS-managed migration of NOAA PAM-Cloud

  
PAMHUB is a NERACOOS-hosted migration and reimplementation of NOAA Fisheries’ PAM-Cloud system. PAMHUB provides passive acoustic monitoring (PAM) ingestion, storage, processing, visualization, and archival export capabilities similar in purpose and user workflow to NOAA’s PAM-Cloud, but implemented and operated outside NOAA cloud infrastructure and targeted primarily at non-NOAA scientists.

**Badges**  
(Replace placeholders with real badges as CI / docs / license are added)
- ![build status](https://img.shields.io/badge/build-pending-lightgrey)
- ![license](https://img.shields.io/badge/license-TBD-blue)
- ![docs](https://img.shields.io/badge/docs-coming%20soon-lightgrey)

**Table of contents**
- **Project overview**
- **Motivation & goals**
- **Scope & assumptions**
- **Key features**
- **High-level architecture**
- **Quickstart — developer**
- **Quickstart — scientist user**
- **Configuration & environment**
- **Deployment & operations**
- **Data & security**
- **Contributing**
- **Roadmap**
- **Testing**
- **Examples**
- **Maintenance & governance**
- **License**
- **Contacts**
- **Acknowledgements & references**

## Project overview
PAMHUB rehosts and reimplements the functional baseline of NOAA Fisheries’ PAM-Cloud to provide a regionally-operated, scientist-friendly PAM platform. The goal is to give non-NOAA researchers and institutions a supported cloud service for storing, processing, visualizing, and exporting PAM data, while maintaining interoperability with common archival patterns where practical.

### Motivation & goals
- Provide the regional ocean-observing and marine research communities with a maintained PAM cloud platform under NERACOOS operations.
- Reproduce core PAM-Cloud workflows: ingestion, standardized object storage, containerized/batch processing, derived-product generation, visualization, and export/archival hooks.
- Prioritize accessibility and clear onboarding for non-NOAA scientists.
- Implement infrastructure, policies, and tooling appropriate to NERACOOS (may differ from NOAA choices while preserving essential functionality).

### Scope & assumptions
- NOAA PAM-Cloud documentation is used as the functional baseline that PAMHUB maps to. PAMHUB aims for similar behavior and user workflows, not necessarily identical APIs or internal architecture.
- PAMHUB will run outside NOAA-managed cloud accounts and therefore may use different providers, IAM models, storage classes, and operational tooling.
- Data subject to NOAA-specific restrictions remain subject to their original policies — migration does not change access rights unless explicitly authorized by data owners.
- The first delivery targets a Minimum Viable Product (MVP) focused on ingestion, storage, basic processing, and a simple web UI for scientists.
- PAMHUB will not have write access to Makara Database
- PAMHUB will not have read access to Makara Database


## Key features (target parity)
TODO: Update this section or eliminate.

- Standardized object storage layout and lifecycle recommendations for hot/cold data management.
- Ingest connectors (HTTPS, SFTP, agent-based upload) and standardized metadata enforcement.
- Containerized/batch processing pipelines to produce derived acoustic products.
- Web UI for browsing datasets, starting processing jobs, and viewing visualizations.
- RESTful APIs for programmatic access and scripted workflows.
- Export and packaging routines for archival compatibility (configurable to match national or regional archive requirements).
- Monitoring, logging, and operational dashboards suitable for a production-managed service.

## Roadmap
See [roadmap.md](roadmap.md) for the current development goals.  

Track milestones in GitHub Issues, Projects, and Milestones.



### High-level architecture
(See [architecture.md](architecture.md) for diagrams and an expanded description of PAMHUB.

- Ingest layer: authenticated upload endpoints and connector agents.
- Storage layer: object store with metadata catalog and lifecycle policies.
- Processing layer: orchestrated container jobs (Kubernetes jobs, managed batch, or serverless tasks).
- Visualization: Visualization for select products.  Building on the [SoundCOOP Visualization system](https://soundcoop.portal.axds.co)
- Ops: monitoring, alerting, logs, backups, and runbooks.
- Archival/export: dataset packaging and export workflows to NOAA/NCEI archive.

### Contributing
TBD

## Example usage



### Quickstart — data provider user




**Testing**

**Examples**


**License**  
TBD - NERACOOS preferences?

**Contacts**
- NERACOOS operations lead — (add name and email)  
- Project manager — (add name and email)  
- PAM Analyst - 
- For PAM-Cloud baseline questions, refer to [NOAA PAM-Cloud documentation](https://nmfs-ost.github.io/PAM-Cloud/).

**Acknowledgements & references**
- NOAA Fisheries PAM-Cloud — baseline functional reference (source of the functional baseline).

