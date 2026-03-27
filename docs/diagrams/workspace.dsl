workspace "PAMHUB" "Passive Acoustic Monitoring Data Platform" {
	
	!impliedRelationships true
	
	
	model {
		
		# ── Actors ───────────────────────────────────────────────────────────────
		
		dataProvider = person "Data Provider" "Submits acoustic recordings, metadata, and derived products." "External Person"
		
		analyst = person "PAM Analyst" "Reviews, annotates, and approves processed data via cloud workstation."
		
		
		# ── Systems ──────────────────────────────────────────────────────────────
		
		acousticPlatform = softwareSystem "PAMHUB" "Ingests acoustic data, orchestrates processing pipelines, and delivers output products." {
			
			# ── Containers ───────────────────────────────────────────────────────
			
			ingest = container "Ingest Service" "Accepts file uploads, validates metadata, and triggers ingestion workflow." "Web Application; REST API; CLI"
			
			rawBucket = container "Raw Data Bucket" "Stores raw acoustic files (wav, FLAC, mp3, other?) and associated metadata (fmt - TBD)." "Cloud Object Store" "Storage"
			
			workflow = container "Workflow Orchestrator" "Schedules and monitors processing pipelines; manages job retries & logging." "Dagster Workflow Engine"
			
			processingWorkers = container "Processing Workers" "Executes algorithms: spectrogram generation, detector models, QA checks." "JupyterHub/Dask"
			
			workstation = container "Cloud Workstation" "Windows VM for analyst annotation review, detection validation & approval." "Virtual Machine"
			
			productsBucket = container "Products Bucket" "Stores processed outputs: spectrograms, detection CSVs, archive packages." "Cloud Object Store" "Storage"
			
			metadataDb = container "Metadata Database" "Tracks deployments, recordings, detections, annotations, workflow state & audit log." "Relational DB" "Database"
			
			deliveryApi = container "Delivery API" "Exposes processed products to downstream systems via authenticated endpoints." "REST API"
			
			# ── Container-to-container relationships ─────────────────────────────
			
			ingest         -> rawBucket         "Writes raw files" "AWS CLI; S3 PutObject"
			ingest         -> metadataDb        "Records ingestion event; metadata" "SQL"
			ingest         -> workflow           "Triggers ingestion run" "?"
			workflow           -> processingWorkers "Dispatches processing jobs" "Job queue / K8s Job"
			workflow           -> metadataDb        "Reads/writes workflow state" "SQL"
			workflow           -> deliveryApi       "Triggers product delivery jobs" "REST"
			processingWorkers -> rawBucket         "Reads raw files" "S3 GetObject"
			processingWorkers -> productsBucket    "Writes output products" "S3 PutObject"
			processingWorkers -> metadataDb        "Records detections & processing results" "SQL"
			workstation       -> metadataDb        "Reads/writes annotations & approvals" "SQL via API"
			workstation       -> productsBucket    "Streams spectrograms for review" "S3 presigned URL"
			workstation       -> workflow          "Triggers approval workflow step" "REST"
			deliveryApi       -> productsBucket    "Reads finalized products" "S3 GetObject"
			deliveryApi       -> metadataDb        "Extracts and formats metadata" "SQL"
		}
		
		ncei = softwareSystem "NCEI Archive" "National Centers for Environmental Information long-term data archive." "External System"
		
		pacm = softwareSystem "PACM" "Passive Acoustic Cetacean Monitor – species detection and reporting platform." "External System"
		
		visualizer = softwareSystem "Visualization Portal" "Interactive web application for exploring acoustic products and annotations." "External Web Page"
		
		# ── System-level relationships (Level 1) ─────────────────────────────────
		
		dataProvider     -> acousticPlatform "Uploads raw acoustic files & metadata" "HTTPS / S3 presigned URL"
		analyst          -> acousticPlatform "Reviews detections, annotates, performs QA/QC, approves products" "Virtual Machine/JupyterHub"
		acousticPlatform -> ncei             "Delivers archived data packages" "HTTPS / SFTP"
		acousticPlatform -> pacm             "Delivers species detection results & reports" "Manual CSV/API ???"
		acousticPlatform -> visualizer       "Delivers processed spectrograms, annotations & metadata" "REST API / S3 event"
		
		# ── Container-to-actor / container-to-external relationships (Level 2) ───
		
		dataProvider                         -> ingest   "Provide acoustic files & metadata" "Asset Manager / AWS CLI upload"
		analyst                              -> workstation "Reviews detections, annotates, approves" "SSH / HTTPS?"
		deliveryApi         -> ncei                         "Pushes archive packages" "HTTPS / S3 "
		deliveryApi         -> pacm                         "POSTs detection reports" "REST API"
		deliveryApi         -> visualizer                   "Publishes products & metadata" "REST API / S3 event"
		
	}
	
	views {
		
		systemContext acousticPlatform "SystemContext" "System Context for the PAMHUB" {
			include *
			autoLayout lr
		}
		
		container acousticPlatform "Containers" "Containers within the PAMHUB" {
			include *
			autoLayout lr
		}
		
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
		}
		
	}
	configuration {
		scope softwaresystem
	}
}
