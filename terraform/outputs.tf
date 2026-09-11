output "raw_landing_bucket_name" {
  description = "Name of the D0 Raw Landing Cloud Storage bucket."
  value       = google_storage_bucket.d0_raw_landing.name
}

output "raw_landing_bucket_url" {
  description = "Google Cloud Storage URL of the D0 Raw Landing bucket."
  value       = google_storage_bucket.d0_raw_landing.url
}

output "staged_enforced_dataset_id" {
  description = "Identifier of the D1 Staged/Enforced BigQuery dataset."
  value       = google_bigquery_dataset.d1_staged_enforced.dataset_id
}
output "data_pipeline_service_account" {
  description = "Email address of the dedicated data pipeline service account."
  value       = google_service_account.data_pipeline.email
}