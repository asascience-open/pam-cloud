# Use Case: Upload raw data to PAMHUB

**ID:** UC-005  
**Primary Actor:** PAM Data Provider (or PAM Analys on their behalf)  
**Goal:** Upload any relevant data file to the PAMHUB cloud environment for subsequent processing.  

## 1. Descriptions

**Trigger:** A data provider has recovered PAM observation platfomr (e.g. mooring, glider), downloaded data from the recorders, and is ready to share data with PAMHUB.

**Pre-conditions:**

- Data Provider has an account in Asset Manager and a storage bucket has been created to receive input data.
- Data Provider has assembled and formatted metadata that follows the guidance form NOAA/NMFS Northeast Fisheries Science Center's [Makara Data Submission Guide](https://www.fisheries.noaa.gov/s3/2025-08/Makara-Data-Submission-Guide-508.pdf)

**Basic Flow:** The "Happy Path" where everything goes as expected.
**Alternative Flows:** Scenarios where the user takes a different path or an error occurs.
**Priority:** High

There are 3 types of data "packages" that might be provided.

1. **Raw unprocessed**:  Raw audio data with minimal metadata.  All processing will be done in the PAMHUB environment.
2. **Raw processed**: Raw audio data that has been QC'd by the data provider.  Data files are organized according to TBD standard and metadata complies with the [Makara Data Submission Guide](https://www.fisheries.noaa.gov/s3/2025-08/Makara-Data-Submission-Guide-508.pdf)
3. **Products**: In addition to, or instead of providing raw audio files, the data provider will provide processed data prodcuts such as Species Detections, computed Spectogram files (TODO: HMD file format reference needed here.)

## 2. Basic Flow (Happy Path)

> ![NOTE] As written, the Basic Flow path pertains to item 2 above, "Raw processed data package."

- Data Provider successfully logs in to Asset Manager web application
- Asset Manager prompts for dataset information to determine what type of data package will be provided
- Data Provider either:
  - Manually enters deployment metadata (e.g., deployment locations, instrument specifications and recording cycles) into the PAMHUB Asset Manager interface ([TBD URL]()). At this stage the data provider also defines data sharing permissions (PACM visibility, accessibility from other users, etc.).
  - OR, Uploads standardized metadata conatining all of the aforementioned metadata (TBD Exact format and minimal data content required)
- Asset Manager loads metadata into database
- Asset Manager provisions a storage location, with appropriate permissions, for upload and provides instructions to data provider
- Data provider
  - For small data sets, provider uploads data directly into PAMHUB (e.g. drag and drop). Transferring compressed files (e.g. .sud files from SoundTrap recorders) should be preferred when possible.
  - For large data sets, provider follows instructions provided to upload via command line interface tools or other methods

> ![QUESTION] What other notifications or verifications should be here to ensure complete upload?

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
