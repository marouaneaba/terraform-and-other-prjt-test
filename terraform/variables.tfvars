backend_bucket          = "kafka-terraform-state-backend-202402"
gcs_bucket_location     = "ASIA"

gcp_project               = "de-zoomcamp-412415"
gcp_region                = "asia-southeast1 "

compute_instance_image    = "ubuntu-os-cloud/ubuntu-2004-lts"

kafka_instance_name     = "de-projects-kafka"
kafka_instance_type     = "e2-standard-2"
kafka_instance_zone     = "asia-southeast1-b"
kafka_port              = "9092"
kafka_control_port      = "9021"
kafka_disk_size         = 50