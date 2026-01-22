# PAMHUB 

PAMHUB is a NERACOOS-hosted migration and reimplementation of NOAA Fisheries’ [PAM-SI Cloud](https://nmfs-ost.github.io/PAM-Cloud/) system. PAMHUB provides passive acoustic monitoring (PAM) ingestion, storage, processing, visualization, and archival export capabilities similar in purpose and user workflow to NOAA’s PAM-SI Cloud, but implemented and operated outside NOAA cloud infrastructure and targeted primarily at [non-NOAA scientists](docs/data-providers.md). The goal is to give non-NOAA researchers and institutions a supported cloud service for storing, processing, visualizing, and exporting PAM data, while maintaining interoperability with common archival patterns where practical.

## Motivation & goals
- Provide the regional ocean-observing and marine research communities with a maintained PAM cloud platform under NERACOOS operations.
- Reproduce core PAM-SI Cloud workflows: ingestion, standardized object storage, containerized/batch processing, derived-product generation, visualization, and export/archival hooks.
- Prioritize accessibility and clear onboarding for non-NOAA scientists.
- Implement infrastructure, policies, and tooling appropriate to NERACOOS (may differ from NOAA choices while preserving essential functionality).

## Roadmap
See [roadmap.md](docs/roadmap.md) for the current development goals.  GitHub Issues, Projects, and Milestones will be used to track and plan project progress.

## High-level architecture
See [architecture.md](docs/architecture.md) for diagrams and an expanded description of PAMHUB.

## Contributing
Contributions are restricted to the core project team at this time.

## License  
TBD

## Acknowledgements & references
- NOAA Fisheries PAM-SI Cloud — baseline functional reference (PAMHUB replicates many of the PAM-SI (aka PAM-Cloud) functions but is not a complete migration). [NOAA PAM-Cloud documentation](https://nmfs-ost.github.io/PAM-Cloud/).

