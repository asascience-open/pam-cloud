# Use Case: Pre-upload Data Integrity Check

**ID:** UC-011  
**Primary Actor:** Data provider
**Goal:** Ensure all files on local disk are present prior to upload.  Identify suspect temporal gaps in record.

## 1. Descriptions

**Trigger:** The specific action or event that kicks off the process.
**Pre-conditions:** User is logged in to Asset Manager or Upload Checker webapp. All files are available in local disk.
**Basic Flow:** The "Happy Path" where everything goes as expected.
**Alternative Flows:** Identify gaps and rectify, rerun checker
**Priority:** Low

## 2. Basic Flow (Happy Path)
Actor [performs action].
System [responds to action].
Actor [next step].
System [confirms goal is met].

Below is from design presentation:
Data Integrity (client initiates via webapp): (TODO: Add this detail to uc-011-pre-upload-integrity-check.md)
Basic check of data gaps based on file names and duration. An example of basic data integrity tool that can be run in a web browser on the client side is implemented in the GitHub repo here: https://github.com/xaviermouy/PAMHub_tools. The script of interest is audio_qc_basics_UI.py. It can be deployed online serverless using Pyodide: https://xaviermouy.github.io/PAMHub_tools/audio_qc_basics_UI.html.
#CT# Xavier mentioned that uploading welfleet data to the bucket was challenged by freezes/crashes - we’ll have to be sure this processes is as smooth as possible to not discourage data providers
Initially, test using the Pyodide generated webapp.  Eventually, integrate the webapp functionality into AssetManager Webapp.  
Container: Asset Manager and Ingest Service 


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
