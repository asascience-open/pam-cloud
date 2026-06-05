workspace "PAMHUB" "Passive Acoustic Monitoring Data Platform" {
	
	!impliedRelationships true
	!adrs decisions
	!docs .
	
	model {
		
		# ── Actors ───────────────────────────────────────────────────────────────
		
		dataProvider = person "Data Provider" "Submits acoustic recordings, metadata, and derived products." "External Person"
		
		analyst = person "PAM Analyst" "Reviews, annotates, and approves processed data via cloud workstation."
		
		
		# ── Systems ──────────────────────────────────────────────────────────────
		
		acousticPlatform = softwareSystem "PAMHUB" "Ingests acoustic data, orchestrates processing pipelines, and delivers output products." {
			
			# ── Containers ───────────────────────────────────────────────────────
			
			ingest = container "Ingest Service" "Create user/project environment, accepts file uploads." "Web Application; REST API; CLI" {
				asset-manager = component "Asset Manager" "Accepts metadata file uploads, input/edit/validate metadata, and triggers ingestion workflow." "Web Application; FastAPI" "Web Page"
				data-integrity-checker = component "Data Integrity Checker" "Inspect user files before upload for errors" "Pyodide/PAMHUB Tools" "Web Page"
				upload-cli = component "Data Upload CLI" "Interface to AWS upload CLI" "AWS CLI" "Shell"
			}
			
			rawBucket = container "Raw Data Bucket" "Stores raw acoustic files (wav, FLAC, mp3, other?) and associated metadata (fmt - TBD)." "Cloud Object Store" "Storage"
			
			dagster-service = container "Dagster Orchestration" "Administer Dagster OSS components; Orchestrate PAMHUB Flows" "K8s/Docker/AWS?"  {
				
				hmd-workflow = component "HMD Pipeline" "Schedules and monitors HMD file creation processing pipelines; manages job retries & logging." "Dagster Flow/Dask/Python"
				detector-workflow = component "Detector Pipeline" "Schedules and monitors species detection workflows; manages job retries & logging." "Dagster Flow/Dask/Python" "Priority3"
				ncei-workflow = component "Archive Package Pipeline" "Create and publish archive package for raw audio files" "Dagster Flow/Dask/Python"
				extract-hmd-visuals-workflow = component "Update HMD Visualization" "Create new HMD-based metrics and publish to visualization service." "Dagster Flow/Python" "Priority2"
			}
			
			workstation = container "JupyterHub" "Development environment for one-off analysis and data pipeline invocation." "JupyterHub"  "Web Page"
			
			productsBucket = container "Products Bucket" "Stores processed outputs: spectrograms, detection CSVs, archive packages." "Cloud Object Store" "Storage"
			
			metadataDb = container "Metadata Database" "Tracks deployments, recordings, detections, annotations, workflow state & audit log. Makara like." "Relational DB" "Database"
			
			deliveryApi = container "Delivery API" "Exposes processed products to downstream systems via authenticated endpoints." "REST API"
			
			# Repo for soundscope: https://github.com/xaviermouy/SoundScope
			soundscopeVis = container "SoundScope Analysis/Visualization" "Visualize using SoundScope TBD" "UNKNOWN" "Web Page, Priority3"
			
			# ── Container-to-container relationships ─────────────────────────────
			
			# Ingest
			ingest  -> metadataDb        "Create/Update metadata" "SQL"
			ingest  -> rawBucket         "Create/Update data and products" "AWS CLI; S3 PutObject; Other?"
			
			# Direct interaction between JupyterHub and data
			workstation       -> rawBucket         "Read raw files" "S3 GetObject/?"
			workstation       -> metadataDb        "Read/write metadata" "SQL via ??"
			workstation       -> productsBucket    "Write analysis results" "S3 PutObject/Xarray?"
			
			# Workstation initiates data pipelines
			workstation    -> dagster-service      "Launch data pipeline" "Dagster/Python"
			dagster-service   -> metadataDb        "Read metadata" "SQL"
			dagster-service   -> productsBucket       "Write product files" "S3 PutObject/Xarray/?"
			dagster-service -> rawBucket         "Read raw files" "S3 GetObject/?"
			dagster-service -> deliveryApi        "Publish data and products" "UNKNOWN"
			
			deliveryApi       -> productsBucket    "Extracts and formats finalized products" "S3 GetObject"
			deliveryApi       -> metadataDb        "Extracts and formats metadata for publication" "SQL"
			
			# ── Coomponent-to-component relationships ─────────────────────────────
			asset-manager  -> metadataDb "Create/Update metadata" "SQL?"
			asset-manager -> rawBucket "Create user partition for raw audio" "FastAPI"
			upload-cli -> rawBucket "Upload raw audio" "AWS CLI"
			
		}
		
		ncei = softwareSystem "NCEI Archive" "National Centers for Environmental Information long-term data archive." "External System"
		
		visualizer = softwareSystem "Visualization Portal" "Interactive web application for exploring acoustic products and annotations." "External Web Page, Priority2"
		
		# ── System-level relationships (Level 1) ─────────────────────────────────
		
		dataProvider     -> acousticPlatform "Uploads raw acoustic files & metadata, reviews detections" "HTTPS"
		dataProvider     -> soundscopeVis "Analyzes raw audio, perform QC, review and approve detections" "JupyterHub"
		analyst          -> acousticPlatform "Performs QA/QC, triggers workflow, approves products" "JupyterHub"
		acousticPlatform -> ncei             "Delivers archived data packages" "HTTPS / SFTP"
		acousticPlatform -> visualizer       "Delivers processed spectrograms, annotations & metadata" "REST API / S3 event"
		
		# ── Container-to-actor / container-to-external relationships (Level 2) ───
		
		dataProvider     -> asset-manager   "Create/upload/edit project metadata" ""
		dataProvider     -> data-integrity-checker "Check files on user disk before upload" "Pyodide"
		dataProvider     -> upload-cli   "Upload raw audio files (products?)" "AWS CLI upload"
		analyst          -> workstation "Reviews detections, annotates, approves" "SSH / HTTPS"
		deliveryApi      -> ncei                         "Pushes archive packages" "HTTPS / S3 "
		deliveryApi      -> visualizer                   "Publishes products & metadata" "REST API / S3 event"
		
		# This interaction is TBD based on cost
		dataProvider -> workstation "Analyze PAM data and products" "JupyterHub"
		# It is sprobably better to include soundscope as a component of the JupyterHub workstation.
	}
	
	views {
		
		systemContext acousticPlatform "c4-system-context" "System Context for the PAMHUB" {
			include *
			# autoLayout lr
		}
		
		container acousticPlatform "c4-containers" "Containers within the PAMHUB" {
			include *
			# autoLayout lr
		}
		
		component dagster-service "c4-component-dagster" "Data pipelines orchestrated by Dagster" {
			include *
			autoLayout lr
		}
		
		component ingest "c4-component-ingest" "Components of the Ingest Service" {
			include *
			autolayout lr
		}
		
		# Use Case 012 Upload project metadata (and create user partition in bucket)
		dynamic ingest "uc-012-create-project-and-metadata" "Create new project and upload metadata" {
			dataProvider -> asset-manager "Enter or upload new project metadata"
			asset-manager -> metadataDb "Load project metadata"
			asset-manager -> rawBucket "Create project partition/directory"
			asset-manager -> dataProvider "Provide user credentials and upload instructions"
		}
		
		# Use Case 011 Pre Upload integrity check
		dynamic ingest "uc-011-data-integrity" "Check data integrity prior to uploading" {
			dataProvider -> data-integrity-checker "Provide local path to raw audio"
			data-integrity-checker -> dataProvider "Run audio_qc_basics.py via Pyodide"
			autolayout lr
		}
		
		# Use Case Upload raw audio files
		
		
		
		# TODO: (Pri1) dynamic view to perform analysis and QC uc-007-quality-control-raw-audio.md
		# TODO: (Pri1) dynamic view for creating HMD files uc-002-calculate-spectograms.md
		# TODO: (Pri1) dynamic view to archive at NCEI uc-001-archive-pam-data-at-ncei.md
		# TODO: (Pri2) dynamic view to update HMD climatology and publish to visualization server
		# TODO: (Pri2) Write use case on extracting HMD metrics to publish to visualization server
		# TODO: (Pri3) dynamic view to run a species detector uc-003-detect-species-presence.md
		# TODO: (Pri3) Analyze and understand SoundScope visualization use case
		# TODO: (Pri3) Write use case defining external PI (data provider) interacting with the Jupyterhub. uc-010-external-investigator-analysis.md
		# TODO: (Pri4) dynamic view to publish detections to PACM and/or NCEI uc-008-publish-detections.md
		# TODO: (Pri4) Write use case on publishing detections to PACM and/or NCEI uc-008-publish-detections.md
		
		styles {
			element "Person" {
				shape Person
				background "#08427b"
				color "#ffffff"
				stroke "#052d56"
			}
			element "External Person" {
				shape Person
				background "#999999"
				color "#ffffff"
				stroke "#6b6b6b"
			}
			element "Software System" {
				shape RoundedBox
				background "#1168bd"
				color "#ffffff"
				stroke "#0b4884"
			}
			element "Web Page" {
				shape WebBrowser
				background "#1168bd"
				color "#ffffff"
				stroke "#0b4884"
			}
			element "Shell" {
				shape Shell
				background "#1168bd"
				color "#ffffff"
				stroke "#0b4884"
			}
			element "Terminal" {
				shape Terminal
				background "#1168bd"
				color "#ffffff"
				stroke "#0b4884"
			}
			element "External Web Page" {
				shape WebBrowser
				background "#999999"
				color "#ffffff"
				stroke "#6b6b6b"
			}
			element "External System" {
				shape RoundedBox
				background "#999999"
				color "#ffffff"
				stroke "#6b6b6b"
			}
			element "Container" {
				shape RoundedBox
				background "#1168bd"
				color "#ffffff"
				stroke "#0b4884"
			}
			element "Database" {
				shape Cylinder
				background "#1168bd"
				color "#ffffff"
				stroke "#0b4884"
			}
			element "Storage" {
				shape Cylinder
				background "#1168bd"
				color "#ffffff"
				stroke "#0b4884"
			}
			element "Priority1" {
				background "#1168bd"
			}
			element "Priority2" {
				background "#11bd22"
			}
			element "Priority3" {
				background "#bd8711"
			}
			element "Priority4" {
				background "#c05b5b"
			}
		}
		
	}
	configuration {
		scope softwaresystem
	}
}
