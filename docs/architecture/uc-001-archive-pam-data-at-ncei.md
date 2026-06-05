# Use Case: Archive Raw PAM Data with NCEI

**ID:** UC-001

**Goal:** Submit a raw audio dataset and associated metadata for long-term archiving at NCEI

TODO: 

---

## 1. Descriptions

**Primary Actor:** PAM Data Provider (or PAM Analyst on their behalf)

**Trigger:** A data provider has uploaded PAM acoustic data, and is ready to begin the archiving process.

**Pre-conditions:**

- To be refined based on resources and references provided by [NCEI](https://www.ncei.noaa.gov/products/passive-acoustic-data)
- Sufficient metadata exists and is properly formatted
- Data files comply with NCEI standards

**Post-conditions:**

- Accession number has been created
- DOI has been created
- Data from the data provider are publicly available on the NCEI PAD Google bucket ([https://console.cloud.google.com/storage/browser/noaa-passive-bioacoustic](https://console.cloud.google.com/storage/browser/noaa-passive-bioacoustic)) and discoverable on the NCEI Passive Acoustic Data Map ([https://www.ncei.noaa.gov/maps/passive-acoustic-data](https://www.ncei.noaa.gov/maps/passive-acoustic-data))
- Data is publicly accessible on the NOAA Open Data Dissemination (NODD) website and cloud buckets (the specific cloud and access method is determined at the time of archiving.)

**Priority:** High

## 2. Basic Flow (Happy Path)

The exact steps are TBD.
Relevant systems and decisions.
1. metadata database
2. PACE/PassivePacker are they required in PAMHUB or are we replicating that functionality elsewhere?
3. Exact format of archive package.
4. Role of ATRAC or other Archive tools (Send2NCEI)


## 3. Alternative / Exception Flows

### 3.1 Data volume too large for internet transfer

Includes, data volumes are too large and therefore egress fees are too expensive for cloud to cloud transfer.

### 3.2 Other

> TBD

### 3.3 Other TBD failure

> TBD

## 4. Special Requirements

!!! NOTE
    TBD — Requirements will be captured by the PAM Analyst during manual NCEI archiving interactions in the first increment and passed to the development team for incorporation here.

TODO: Refine archiving use case based on PAM Analyst's review