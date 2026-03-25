# Use Case: [Name of Use Case]

**ID:** UC-001  
**Primary Actor:** [e.g., Customer, Admin]  
**Goal:** [Summary of what the actor wants to achieve]  

## 1. Descriptions

**Trigger:** The specific action or event that kicks off the process.
**Pre-conditions:** Requirements that must be met before the user can start (e.g., "User is logged in").
**Basic Flow:** The "Happy Path" where everything goes as expected.
**Alternative Flows:** Scenarios where the user takes a different path or an error occurs.
**Priority:** [High / Medium / Low]

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

## Notes from past documents to be incorporated into uc-005
# Uploading Data to the Cloud Analysis Environment

Placeholder document for the data upload chapter of the documentation.

## Types of Data

- Raw audio files
- Detections
- Deployment and Platform metadata

 TODO: As the requirements for data formats becomes clear, include links to any related documentation, templates, example data sets etc., here. This could also include file and directory organization, metadata requirements, and standards references.

## Metadata Formats and Content Standards

- PACM Upload format
- Tethys data model
- Makara data model
- ??

## Tools and Procedures

- Google CLI (AWS equivalent)
- Web Portal update/editing (To be decided)
- Transfer appliance (for data sets too large to upload over the network)
