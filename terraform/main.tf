provider "google" {
  project = var.project_id
  region  = var.region
}

# D0 Raw Landing
# Secure Cloud Storage bucket for raw incoming data.
resource "google_storage_bucket" "d0_raw_landing" {
  name                        = var.raw_bucket_name
  location                    = var.region
  uniform_bucket_level_access = true

  public_access_prevention = "enforced"

  versioning {
    enabled = true
  }

  soft_delete_policy {
    retention_duration_seconds = 604800
  }
}

# D1 Staged/Enforced
# BigQuery dataset for validated and governed data.
resource "google_bigquery_dataset" "d1_staged_enforced" {
  dataset_id = var.bigquery_dataset_id
  location   = var.region

  delete_contents_on_destroy = false

  labels = {
    data_layer  = "d1"
    environment = "staged-enforced"
  }
}