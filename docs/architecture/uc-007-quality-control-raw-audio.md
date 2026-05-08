# Use Case: Quality Control raw audio files

**ID:** UC-007  
**Primary Actor:** PAM Analyst  
**Goal:** Quality control raw audio files to ensure they are prepared for archival at NCEI or subsequent data processing.  Extract relevant metadata and load database.  

## 1. Descriptions

**Trigger:** TBD

**Pre-conditions:** 

- Raw unprocessed audio files has been uploaded into PAMHUB and is staged in the storage bucket.
- Project metadata exists in the metadataDB

**Priority:** Medium / Low

## 2. Basic Flow (Happy Path)
Actor [performs action].
System [responds to action].
Actor [next step].
System [confirms goal is met].

1. PAM Analyst logs in to the JupyterHub analysis environment which has a suite of analysis tools already configured.
2. PAM Analyst starts the QA/QC process. This consists of:
   1. running R and python routines to detect times and frequency bands of the data that may have issues (e.g. noise, data gaps, etc) and 
   2. manually verifying a portion of the data that were flagged by the scripts. If the data uploaded by the data provider are compressed (e.g. sud file), the PAM Analyst will first need to decompress the data (e.g. using the SoundTrap software)  
3. PAM Analyst creates a QA/QC report and uploads it to the temporary data bucket for the data provider to review.  
4. Data provider uses temporary cloud workstation to access the QA/QC report and to verify a section of the data flagged using standard (e.g. Raven) and custom (e.g. possibly R/python GUI) software.  
5. QC Report is loaded into the database to be available for subsequent archiving steps.

!!! TODO
    Verify the interaction between analyst and data provider implied above.  The process is very vague.  Further, we're making assumptions about the Data Providers interaction that should be verified.

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
