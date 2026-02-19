# Architecture of the PAMHUB System

## Static Structure

- Ingest layer: authenticated upload endpoints and connector agents.
- Storage layer: object store with metadata catalog and lifecycle policies.
- Processing layer: Manual cloud based workstation (pam-ww) or batch scaling.
  - Research the SoundScapes data processing worklflow to see what we can reuse.
- Visualization: Visualization for select products.  Possibly, building on the [SoundCOOP Visualization system](https://soundcoop.portal.axds.co)
- Operations: monitoring, alerting, logs, backups, and cost management.
- Export layer: dataset packaging and export workflows for downstream customers (e.g. NOAA/NCEI archive, PACM).

![System Landscape][pam-cloud-system]

## Data Flow

![High level data flow][dataflow]

## Data Model

Metadata and configuration files platform, detections, ancillary data.

### Platform and Deployment Metadata

> [!CAUTION]
> There is a pending decision regarding the dependence on the Makara Database system and the database model in Makara.  If this project chooses to diverge from the Makara data system then we will need to decide on a new metadata model.  This impacts the way we record platform and deployment metadata as well as species detections from different detectors.
>

Adopting the Makara database structure for metatdata and detection management?

-OR-

Adopting the metadata model that underpins Tethys?

### Detections


### Quality Control Results



### Archive Data and Metadata Formats


[dataflow]: images/pamhub-workflow.svg
[pam-cloud-system]: images/pam-cloud-system.svg