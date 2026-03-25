# Use Case: Detect Species Presence

**ID:** UC-003
**Goal:** Run one or more species detection workflows on a stored raw dataset and distribute verified results to downstream portals

---

## 1. Descriptions

**Primary Actor:** PAM Analyst
**Trigger:** Raw PAM data are available in PAMHUB storage and the PAM Analyst initiates a species detection workflow for one or more deployments.
**Pre-conditions:** TBD
**Post-conditions:** TBD
**Priority:** High

## 2. Basic Flow (Happy Path)

> **Note:** This section is pending completion. The basic flow will vary depending on which species detectors are in scope and which orchestration tool is confirmed. Two distinct sub-flows are anticipated and may need to be split into separate use cases:
>
> - **Sub-flow A:** Cross-platform, scriptable detectors integrated into the orchestration workflow (e.g., a Dagster pipeline)
> - **Sub-flow B:** Windows-only, GUI-driven detectors such as LFDCS that require a separate integration strategy (see Decision 2b)
>
> Do not consolidate these sub-flows until decision on detector architecture and metadata database are resolved.
>

Draft steps from original user story which only focused on LFDCS.  Retained until this use case is fully revised.

- Create LFDCS Whale detections, archive at NCEI, and publish to PACM 
  - Create deployment metdata
  - Upload raw audio and metadata to cloud via asset manager
  - Launch pam-ww cloud workstation
  - Quality control raw audio
  - Run LFDCS detector
    - Create LFDCS config parameter file
    - Run LFDCS detector on pam-ww cloud workstation
  - Quality control LFDCS output, approve detections
  - Create LFDCS archive package
  - Archive LFDCS archive package at NCEI
  - _Upload LFDCS detections to Makara and PACM (NOTE: To be verified)_

## 3. Alternative / Exception Flows

### 3.1 Detector produces no results for a deployment

> TBD

### 3.2 Manual verification fails — analyst does not confirm detections

> TBD

### 3.3 Windows-only detector cannot be run in the standard orchestration environment

> TBD — is this a true statement?

## 4. Special Requirements

> TBD — Known considerations:
>
> - Some detectors (e.g., LFDCS) are currently believed to run only on MS Windows and use GUI-driven interfaces. These cannot be integrated into a standard pipeline without additional infrastructure.
> - Manual verification of detections is required before results are distributed to downstream portals such as PACM.
> - Distribution targets include PACM and NCEI. Distribution format requirements for each are TBD.

---

*Status: Stub — intentionally incomplete. Do not begin implementation design against this document until Sections 2 and 3 are populated, Decision 2b is resolved, and the document is marked Ready for Review.*
