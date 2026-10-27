# PAMHUB User Manual

## Metadata Handling

!!! TODO
    The list below needs elaboration and examples.

- Define the types of metadata collected
  - Platform, Deployment, Project, ????
- Provide metadata to the PAM Analyst (email, FTP etc.)
- PAM Analyst will review the metadata and standardize it according to the metadata model documented here.
  - Links to [PARS](https://passiveacoustics.fisheries.noaa.gov/pars/guide/metadata.html)
  - Links to Tugboat [API docs](https://ccog.colorado.edu/tugboat/swagger-ui/index.html)
  - Links to NCEI archiving [best practices](https://www.ncei.noaa.gov/products/passive-acoustic-data#tab-3561)
  - Links to any other reference that informed the metadata model implemented in PAMHUB.
  - Links to csv templates for Data Providers
- PAM Analyst will work iteratively with the data provider to ensure the metadata is of sufficient quality to support all of the PAMHUB use cases (e.g. archiving data and derived products, calculating spectograms and creating HMD files, calculating climatological soundscape metrics, detecting species presence or absence, etc.)

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#003478', 'primaryTextColor': '#FFFFFF', 'primaryBorderColor': '#000000', 'lineColor': '#000000' }}}%%
flowchart TB
    classDef qc fill:#B0C4DE,stroke:#003478,stroke-width:2px,color:#000000;
    classDef storage fill:#FFFFFF,stroke:#000000,stroke-width:2px,color:#000000;
    classDef doc fill:#FFFFFF,stroke:#000000,stroke-width:1.5px,stroke-dasharray: 0,color:#000000;
    classDef process fill:#FFFFFF,stroke:#000000,stroke-width:1.5px,color:#000000;

    subgraph DataProviderArea["Data Provider"]
        direction TB
        S1["1. Metadata from data provider"]:::doc
        S5[("5. Raw audio data")]:::storage
        S6["6. Data integrity verification"]:::qc
        S17_Review["Check integrity with data provider"]:::process
        DataProvider_QC["Data provider (Review)"]:::process
    end

    subgraph PAMHub["PAM Hub"]
        direction TB
        S2["2. Metadata data upload (intake form)"]:::process
        S3["3. Quality control of metadata"]:::qc
        S4[("4. Metadata database")]:::storage
        S7["7. AWS data upload"]:::process
        S8["8. Data integrity verification"]:::qc
        S9[("9. Raw audio data")]:::storage
        S17["17. Cloud Data Summary Report"]:::doc
        S10["10. HMD processing (Nebari)"]:::process
        S11["11. HMD data products (nc files)"]:::doc
        S12["12. Quality control of HMD data"]:::qc
        S13["13. Data QC report"]:::doc
        S14[("14. QA/QC database")]:::storage
        S15["15. Add QC fields to nc files"]:::process
        S16["16. HMD data products with QC matrix (nc files)"]:::doc
    end

    subgraph NCEI["NCEI"]
        NCEI_Raw["Raw Audio Archive"]:::process
        NCEI_HMD["HMD Products Archive"]:::process
    end

    %% Metadata track
    S1 --> S2
    S2 --> S3
    S3 --> S4

    %% Audio ingestion track
    S5 --> S6
    S6 --> S7
    S7 --> S8
    S8 --> S9
    S8 --> S17
    S17 --> S17_Review

    %% Processing & QC track
    S4 --> S10
    S9 --> S10
    S9 -.-> S12
    S10 --> S11
    S11 --> S12

    %% Metadata feedback loop
    S12 -. "Correct metadata if needed (deployment start/end dates)" .-> S4

    %% QC reporting & output track
    S12 --> S13
    S13 --> DataProvider_QC
    S13 --> S14
    S14 --> S15
    S15 --> S16

    %% Delivery to NCEI
    S9 -->|To NCEI| NCEI_Raw
    S16 -->|To NCEI| NCEI_HMD
```
    
## Uploading Raw Audio Files

TODO: Copy content from Issue [#3](https://github.com/asascience-open/pam-cloud/issues/3)


## Quality control of audio files or metadata within the PAMHUB system


## Creation of HMD files


## Quality Control of HMD Files

