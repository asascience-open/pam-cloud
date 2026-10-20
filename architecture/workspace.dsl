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
			
			asset-manager = container "Asset Manager" "Create and edit user/project environment and metadata." "Web Application" {
				forms-ui = component "Form UI" "UI to manually input/edit/validate metadata and accept/validate metadata file uploads." "Web Application" "Web Page"
				data-integrity-checker = component "Data Integrity Checker" "Inspect select data provider files before upload for errors" "Web Application" "Web Page"
			}
			upload-cli = container "Data Upload CLI" "Interface to AWS upload CLI" "AWS CLI" "Shell"
			
			dagster-service = container "Dagster Orchestration" "Administer Dagster OSS components; Orchestrate PAMHUB Flows" "K8s/Dagster/Nebari"  {
				extract-metadata-workflow = component "Extract Metadata" "Extract instrument/platform metadata from raw audio files" "Dagster Flow/Asset Manager" "Priority1"
				hmd-workflow = component "HMD Pipeline" "Schedules and monitors HMD file creation processing pipelines; manages job retries & logging." "Dagster Flow/Python" "Priority1"
				detector-workflow = component "Detector Pipeline" "Schedules and monitors species detection workflows; manages job retries & logging." "Dagster Flow/Python" "Priority3"
				ncei-workflow = component "Archive Package Pipeline" "Create and publish archive package for raw audio files" "Dagster Flow/Python" "Priority1"
				extract-hmd-visuals-workflow = component "Extract SoundScape Metrics from HMD" "Create new HMD-based metrics and publish to visualization service." "Dagster Flow/Python" "Priority2"
			}
			
			metadataDb = container "Metadata Database" "Tracks deployments, recordings, detections, annotations, workflow state & audit log. Makara like." "Relational DB" "Database"
			jupyterhub = container "Nebari/JupyterHub" "Development environment for data analysis and data pipeline invocation." "Nebari/JupyterHub"  "Web Page"
			rawBucket = container "Raw Data Bucket" "Stores raw acoustic files (wav, FLAC, mp3, other?) and associated metadata (fmt - TBD)." "Cloud Object Store" "Storage"
			productsBucket = container "Products Bucket" "Stores processed outputs: spectrograms, detection CSVs, archive packages." "Cloud Object Store" "Storage"
			
			visualizer = container "Visualization Portal" "Interactive web application for exploring acoustic products and annotations." "Web Page, Priority2"  "Web Page"
			
			#deliveryApi = container "Delivery API" "Exposes processed products to downstream systems via authenticated endpoints." "REST API"
			
			windows_workstation = container "Windows Workstation" "Windows virtual machine in PAMHUB for analysis" "MS Windows" "Priority1" {
				# Passive Packer https://www.ncei.noaa.gov/products/passivepacker
				# PACE https://github.com/CI-CMG/pace
				# PAMGuard: https://www.pamguard.org/downloadsurvey.html
				# Raven Pro https://www.ravensoundsoftware.com/software/raven-pro/
				# PyPAM https://github.com/lifewatch/pypam
				# Repo for soundscope: https://github.com/xaviermouy/SoundScope
				ww_python = component "Python Environment for Analysis on Workstation" "Metadata repair, visualization, QA/QC" "Anaconda/miniconda" "Priority1"
				raven = component "Raven analysis software" "Analyze metadata, detections, HMD etc." "Windows Application" "Priority1"
				pamguard = component "PamGuard analysis software" "Windows Application" "Priority1"
			}
			
			
			# ── Container-to-container relationships ─────────────────────────────
			
			# asset-manager
			asset-manager  -> metadataDb        "Create/Update metadata" "PostgREST"
			asset-manager  -> rawBucket         "Create/Update data and products" "AWS CLI; S3 PutObject; Other?"
			
			# Direct interaction between JupyterHub and data
			jupyterhub       -> rawBucket         "Read raw files" "S3 GetObject/?"
			jupyterhub       -> metadataDb        "Read/write metadata" "PostgREST"
			jupyterhub       -> productsBucket    "Write analysis results" "S3 PutObject/Xarray?"
			
			# Windows Workstation for manual analysis
			windows_workstation -> metadataDb "Read metadata" "PostgREST"
			windows_workstation -> rawBucket "Read/Write" "Filesystem"
			
			# Nebari/JupyterHub initiates data pipelines
			jupyterhub    -> dagster-service      "Launch data pipeline" "Dagster/Python???"
			dagster-service   -> metadataDb        "Read metadata" "PostgREST"
			dagster-service   -> productsBucket       "Write product files" "S3 PutObject/Xarray/"
			dagster-service -> rawBucket         "Read raw files" "S3 GetObject/"
			dagster-service -> visualizer	"Delivery derived products for visualization" "???"
			
			# ── Coomponent-to-component relationships ─────────────────────────────
			asset-manager  -> metadataDb "Create/Update metadata" "PostgREST"
			asset-manager -> rawBucket "Create user partition for raw audio" "FastAPI"
			upload-cli -> rawBucket "Upload raw audio" "AWS CLI"
			
			
			ncei = softwareSystem "NCEI Archive" "National Centers for Environmental Information long-term data archive." "External System, Priority1"
			
			#visualizer = softwareSystem "Visualization Portal" "Interactive web application for exploring acoustic products and annotations." "External Web Page, Priority2"
			
			# ── System-level relationships (Level 1) ─────────────────────────────────
			
			dataProvider     -> acousticPlatform "Uploads raw acoustic files & metadata, reviews detections"
			dataProvider 	 -> analyst "Collaborate to process data/metadata"
			analyst          -> acousticPlatform "Performs QA/QC, triggers workflow, approves products"
			acousticPlatform -> ncei             "Delivers data packages for archiving"
			#acousticPlatform -> visualizer       "Delivers processed spectrograms, annotations & metadata" "REST API / S3 event"
			
			# ── Container-to-actor / container-to-external relationships (Level 2) ───
			
			dataProvider     -> asset-manager   "Create/upload/edit project metadata" "HTTPS"
			dataProvider     -> data-integrity-checker "Check files on user disk before upload" "???"
			dataProvider     -> upload-cli   "Upload raw audio files (products?)" "AWS CLI upload"
			analyst          -> jupyterhub "Reviews detections, annotates, approves" "SSH / HTTPS"
			analyst          -> windows_workstation "Reviews detections, annotates, approves" "SSH / HTTPS"
			dagster-service      -> ncei                         "Pushes archive packages" "Tugboat API "
			dagster-service      -> visualizer                   "Publishes products & metadata" "REST API / S3 event"
			
			# This interaction is TBD based on cost
			dataProvider -> jupyterhub "Analyze PAM data and products" "JupyterHub" "Priority4"
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
			
			component asset-manager "c4-component-asset-manager" "Components of the asset-manager Service" {
				include *
				autolayout lr
			}
			
			component windows_workstation "c4-component-windows" "Components of the Windows workstation" {
				include *
				autolayout lr
			}
			
			# Use Case 012 Upload project metadata (and create user partition in bucket)
			dynamic asset-manager-ingest "uc-012-create-project-and-metadata" "Create new project and upload metadata" {
				dataProvider -> asset-manager "Enter or upload new project metadata"
				dataProvider -> analyst "Submit non-standard metadata"
				asset-manager -> metadataDb "Load project metadata"
				asset-manager -> rawBucket "Create project partition/directory"
				asset-manager -> dataProvider "Provide user credentials and upload instructions"
			}
			
			# Use Case 011 Pre Upload integrity check
			dynamic pre-upload-qc "uc-011-data-integrity" "Check data integrity prior to uploading" {
				dataProvider -> data-integrity-checker "Run `analyze-raw-subset`"
				data-integrity-checker -> dataProvider "Provide Markdown report with potential errors and omissions."
				autolayout lr
				# TODO: Investigate structurizr note syntax and add note that dataProvider will investigate and fix possible errors on their own computers or negotiate with PAM Analyst.
			}
			
			# Use Case Upload raw audio files
			
			
			
			# TODO: (Pri1) dynamic view to perform analysis and QC uc-007-quality-control-raw-audio.md
			# TODO: (Pri1) dynamic view for creating HMD files uc-002-calculate-spectograms.md
			# PAM Analyst manually triggers Dagster workflow from the jupyterHub;
			# JupyterHub callse Dagster service to run a workflow;
			# Workflow reads raw data, accesses something from the database,
			# and writes HMD netCDF compliant with a standard.
			
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
	