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

This project will implement the Makara database schema behind a web based Asset Manager user interface.  This Asset Manager system is built with modern, robust tools that will be much easier to develop against, deploy, and maintain. The backend is just PostgreSQL with PostgREST on top, and the frontend is a schema-driven admin UI built with React and TypeScript.

[pam-cloud-system-context]: images/pamhub-SystemContext.svg
[pam-cloud-containers]: images/pamhub-Containers.svg