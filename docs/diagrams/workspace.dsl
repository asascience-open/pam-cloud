workspace "PAMHUB" "Passive Acoustic Monitoring Data Platform" {

    !impliedRelationships true


    model {

        # ── Actors ───────────────────────────────────────────────────────────────

        dataProvider = person "Data Provider" "Submits raw acoustic recordings and metadata." "External Person"

        analyst = person "PAM Analyst" "Reviews, annotates, and approves processed data via cloud workstation."

        
        # ── Systems ──────────────────────────────────────────────────────────────

        acousticPlatform = softwareSystem "PAMHUB" "Ingests raw acoustic data, orchestrates processing pipelines, and delivers output products." {

            # ── Containers ───────────────────────────────────────────────────────

            ingestApi = container "Ingestion API" "Accepts file uploads, validates metadata, and triggers ingestion workflow." "Web Application; REST API; CLI"

            rawBucket = container "Raw Data Bucket" "Stores raw acoustic files (WAV, FLAC, Other?) and associated metadata (fmt - TBD)." "Cloud Object Store" "Storage"

            dagster = container "Dagster Orchestrator" "Schedules and monitors processing pipelines; manages job retries & logging." "Workflow Engine"

            processingWorkers = container "Processing Workers" "Executes algorithms: spectrogram generation, detector models, QA checks." "JupyterHub/Dask"

            workstation = container "Cloud Workstation" "Windows VM for analyst annotation review, detection validation & approval." "Virtual Machine"

            productsBucket = container "Products Bucket" "Stores processed outputs: spectrograms, detection CSVs, archive packages." "Cloud Object Store" "Storage"

            metadataDb = container "Metadata Database" "Tracks deployments, recordings, detections, annotations, workflow state & audit log." "Relational DB" "Database"

            deliveryApi = container "Delivery API" "Exposes processed products to downstream systems via authenticated endpoints." "REST API"

            # ── Container-to-container relationships ─────────────────────────────

            ingestApi         -> rawBucket         "Writes raw files" "AWS CLI; S3 PutObject"
            ingestApi         -> metadataDb        "Records ingestion event; metadata" "SQL"
            ingestApi         -> dagster           "Triggers ingestion run" "?"
            dagster           -> processingWorkers "Dispatches processing jobs" "Job queue / K8s Job"
            dagster           -> metadataDb        "Reads/writes workflow state" "SQL"
            dagster           -> deliveryApi       "Triggers product delivery jobs" "REST"
            processingWorkers -> rawBucket         "Reads raw files" "S3 GetObject"
            processingWorkers -> productsBucket    "Writes output products" "S3 PutObject"
            processingWorkers -> metadataDb        "Records detections & processing results" "SQL"
            workstation       -> metadataDb        "Reads/writes annotations & approvals" "SQL via API"
            workstation       -> productsBucket    "Streams spectrograms for review" "S3 presigned URL"
            workstation       -> dagster           "Triggers approval workflow step" "REST"
            deliveryApi       -> productsBucket    "Reads finalized products" "S3 GetObject"
            deliveryApi       -> metadataDb        "Reads delivery manifest" "SQL"
        }

        ncei = softwareSystem "NCEI Archive" "National Centers for Environmental Information long-term data archive." "External System"

        pacm = softwareSystem "PACM" "Passive Acoustic Cetacean Monitor – species detection and reporting platform." "External System"

        visualizer = softwareSystem "Visualizer" "Interactive web application for exploring acoustic products and annotations." "External System"

        # ── System-level relationships (Level 1) ─────────────────────────────────

        dataProvider     -> acousticPlatform "Uploads raw acoustic files & metadata" "HTTPS / S3 presigned URL"
        analyst          -> acousticPlatform "Reviews detections, annotates, approves products" "HTTPS / Web UI"
        acousticPlatform -> ncei             "Delivers archived data packages" "HTTPS / SFTP"
        acousticPlatform -> pacm             "Delivers species detection results & reports" "REST API"
        acousticPlatform -> visualizer       "Delivers processed spectrograms, annotations & metadata" "REST API / S3 event"

        # ── Container-to-actor / container-to-external relationships (Level 2) ───

        dataProvider                         -> ingestApi   "POST acoustic files & metadata" "HTTPS multipart / presigned URL"
        analyst                              -> workstation "Reviews detections, annotates, approves" "HTTPS / Browser"
        deliveryApi         -> ncei                         "Pushes archive packages" "HTTPS / SFTP"
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

}
