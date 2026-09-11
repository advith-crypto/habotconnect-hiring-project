# Dedicated identity for the data pipeline.
# This avoids granting broad project-level permissions to the pipeline.

resource "google_service_account" "data_pipeline" {
  account_id   = "habot-data-pipeline"
  display_name = "HabotConnect Data Pipeline"
  description  = "Dedicated least-privilege identity for the data ingestion pipeline."
}

# The pipeline can manage objects in the D0 Raw Landing bucket.
# The IAM condition restricts the permission to this bucket only.

resource "google_storage_bucket_iam_member" "data_pipeline_raw_access" {
  bucket = google_storage_bucket.d0_raw_landing.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.data_pipeline.email}"

  condition {
    title       = "RawLandingBucketOnly"
    description = "Restrict pipeline object access to the D0 Raw Landing bucket."
    expression  = "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.d0_raw_landing.name}/objects/\")"
  }
}
# BigQuery Row-Level Security
# A user can access only rows whose organization_id matches
# the authenticated BigQuery principal.
resource "google_bigquery_row_access_policy" "student_onboarding_rls" {
  dataset_id = google_bigquery_dataset.d1_staged_enforced.dataset_id
  table_id   = google_bigquery_table.student_onboarding.table_id
  policy_id  = "student_onboarding_principal_access"

  filter_predicate = "organization_id = SESSION_USER()"

  grantees = [
    "allAuthenticatedUsers"
  ]
}