# Use Case: Quality Control raw audio files

**ID:** UC-007  
**Primary Actor:** PAM Analyst  
**Goal:** Quality control raw audio files to ensure they are prepared for archival at NCEI or subsequent data processing.  Extract relevant metadata and load database.  

## 1. Descriptions

**Trigger:** TBD
**Pre-conditions:** Raw unprocessed audio files has been uploaded into PAMHUB and is staged in the storage bucket.
**Basic Flow:** The "Happy Path" where everything goes as expected.
**Alternative Flows:** Scenarios where the user takes a different path or an error occurs.
**Priority:** Medium / Low

## 2. Basic Flow (Happy Path)
Actor [performs action].
System [responds to action].
Actor [next step].
System [confirms goal is met].

1. PAM Analyst creates a temporary virtual cloud Windows workstation for the data provider. The workstation has access to the temporary data bucket and has a [suite of acoustic analysis software](./external-software-dependencies.md) already installed such as Raven, R, python (Anaconda, PyCharm), SoundTrap software.
2. PAM Analyst logs on to the cloud workstation and starts the QA/QC process. This consists of:
   1. running R and python routines to detect times and frequency bands of the data that may have issues (e.g. noise, data gaps, etc) and 
   2. manually verifying a portion of the data that were flagged by the scripts. If the data uploaded by the data provider are compressed (e.g. sud file), the PAM Analyst will first need to decompress the data (e.g. using the SoundTrap software)  
3. PAM Analyst creates a QA/QC report and uploads it to the temporary data bucket for the data provider to review.  
4.  Data provider uses temporary cloud workstation to access the QA/QC report and to verify a section of the data flagged using standard (e.g. Raven) and custom (e.g. possibly R/python GUI) software.  
5.  QC Report is loaded into the database to be available for subsequent archiving steps.

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
