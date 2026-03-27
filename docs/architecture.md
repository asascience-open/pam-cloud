# Architecture of the PAMHUB System

## Static Structure

![System Context][pam-cloud-system-context]

![Containers in PAMHUB][pam-cloud-containers]

> ![NOTE] These diagrams follow the [C4 software diagramming](https://c4model.com) conventions.  Importantly, in these diagrams "Containers" are generic objects that "contain" functionality provided by software packages.  They are simply a level of abstraction that allows for showing different levels of detail in different diagrams.  THEY ARE NOT DOCKER CONTAINERS!

## Data Flow

TBD Data flow diagrams for select use cases.

## Data Model

Metadata and configuration files platform, detections, ancillary data.

### Platform and Deployment Metadata

> [!CAUTION]
> There is a pending decision regarding the dependence on the Makara Database system and the database model in Makara.  If this project chooses to diverge from the Makara data system then we will need to decide on a new metadata model.  This impacts the way we record platform and deployment metadata as well as species detections from different detectors.
>



[pam-cloud-system-context]: images/pamhub-SystemContext.svg
[pam-cloud-containers]: images/pamhub-Containers.svg