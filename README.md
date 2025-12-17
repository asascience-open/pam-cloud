# PAMHUB 

PAMHUB is a NERACOOS-hosted migration and reimplementation of NOAA Fisheries’ [PAM-SI Cloud](https://nmfs-ost.github.io/PAM-Cloud/) system. PAMHUB provides passive acoustic monitoring (PAM) ingestion, storage, processing, visualization, and archival export capabilities similar in purpose and user workflow to NOAA’s PAM-SI Cloud, but implemented and operated outside NOAA cloud infrastructure and targeted primarily at [non-NOAA scientists](data-providers.md). The goal is to give non-NOAA researchers and institutions a supported cloud service for storing, processing, visualizing, and exporting PAM data, while maintaining interoperability with common archival patterns where practical.

## Motivation & goals
- Provide the regional ocean-observing and marine research communities with a maintained PAM cloud platform under NERACOOS operations.
- Reproduce core PAM-SI Cloud workflows: ingestion, standardized object storage, containerized/batch processing, derived-product generation, visualization, and export/archival hooks.
- Prioritize accessibility and clear onboarding for non-NOAA scientists.
- Implement infrastructure, policies, and tooling appropriate to NERACOOS (may differ from NOAA choices while preserving essential functionality).

## Scope & assumptions
- NOAA PAM-Cloud documentation is used as the functional baseline that PAMHUB maps to. PAMHUB aims for similar behavior and user workflows, not necessarily identical APIs or internal architecture.
- PAMHUB will run outside NOAA-managed Google cloud accounts and therefore may use different operational tooling.
- Data subject to NOAA-specific restrictions remain subject to their original policies — migration does not change access rights unless explicitly authorized by data owners.
- The first delivery targets a Minimum Viable Product (MVP) focused on ingestion, storage, basic manual processing.
- PAMHUB will not have write access to Makara Database
- PAMHUB will not have read access to Makara Database

## Roadmap
See [roadmap.md](docs/roadmap.md) for the current development goals.  

GitHub Issues, Projects, and Milestones will be used to track and plan project progress.


## High-level architecture
See [architecture.md](docs/architecture.md) for diagrams and an expanded description of PAMHUB.

- Ingest layer: authenticated upload endpoints and connector agents.
- Storage layer: object store with metadata catalog and lifecycle policies.
- Processing layer: orchestrated container jobs (Kubernetes jobs, managed batch, or serverless tasks).
- Visualization: Visualization for select products.  Building on the [SoundCOOP Visualization system](https://soundcoop.portal.axds.co)
- Operations: monitoring, alerting, logs, backups, and cost management.
- Archival/export: dataset packaging and export workflows to NOAA/NCEI archive.

## Contributing
TBD

## License  
TBD - NERACOOS preferences?

## Contacts
- NERACOOS operations lead — (add name and email)  
- Project manager — (add name and email)  
- PAM Analyst - 
- For PAM-Cloud baseline questions, refer to [NOAA PAM-Cloud documentation](https://nmfs-ost.github.io/PAM-Cloud/).

## Acknowledgements & references
- NOAA Fisheries PAM-SI Cloud — baseline functional reference (source of the functional baseline).

