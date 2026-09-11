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
# D1 student onboarding table
# The organization_id column provides the row-level security boundary.
resource "google_bigquery_table" "student_onboarding" {
  dataset_id = google_bigquery_dataset.d1_staged_enforced.dataset_id
  table_id   = "student_onboarding"

  schema = <<EOF
[
  {
    "name": "student_id",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "organization_id",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "student_name",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "onboarding_status",
    "type": "STRING",
    "mode": "REQUIRED"
  }
]
EOF

  deletion_protection = true
}