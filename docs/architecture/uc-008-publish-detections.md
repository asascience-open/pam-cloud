# Use Case: Publish detections at PACM

- **ID:** UC-008  
- **Primary Actor:** Data Provider, or PAM Analyst on their behalf 
- **Goal:** Provide Cetacean detections to NOAA for publication on the [Passive Acoustics Cetacean Map (PACM)](https://passiveacoustics.fisheries.noaa.gov/pacm/#/narw)

## 1. Descriptions

- **Trigger:** The PI/data provider has analyzed and approved the detections calculated by a PAMHUB detector.  
- **Pre-conditions:** Detector has run successfully and detections are analyzed by PI.
- **Priority:** 4 Lowest


See [issue 5](https://github.com/asascience-open/pam-cloud/issues/5) for more detail.

The workflow is sketched below:

`[Run Detector] --> [PI Analyzes Detections] --> [Script formats approved detections] -- [[PI Submits to PACM]`

Pushing data to [PACM](https://passiveacoustics.fisheries.noaa.gov/pacm/#/narw) may be requested by users. It can be done manually done for the time being from the workstation. It consists of creating csv files in the format defined in their [guidelines (see Detections).](https://www.fisheries.noaa.gov/s3/2025-08/Makara-Data-Submission-Guide-508.pdf)

The interaction with PACM is indirect as it is either by sending csv files to Jeff at NOAA, or uploading the csv files to their submission portal (when it is up and running).

## 2. Basic Flow (Happy Path)
Actor [performs action].
System [responds to action].
Actor [next step].
System [confirms goal is met].

## 3. Alternative / Exception Flows

### 3.1 [Condition A] (e.g., Invalid Login)
System displays error message.
Use case returns to Step 1 of Basic Flow.

### 3.2 [Condition B] (e.g., Out of Stock)
System suggests alternative products.
Use case terminates. 

## 4. Special Requirements
[e.g., Response time must be under 2 seconds]
[e.g., Mobile responsive layout required]
