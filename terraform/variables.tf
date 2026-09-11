variable "project_id" {
  description = "Google Cloud project ID where the infrastructure would be provisioned."
  type        = string

  validation {
    condition     = length(trimspace(var.project_id)) > 0
    error_message = "The project_id must not be empty."
  }
}

variable "region" {
  description = "Google Cloud region for regional resources."
  type        = string
  default     = "asia-south1"
}

variable "raw_bucket_name" {
  description = "Globally unique name for the D0 Raw Landing Cloud Storage bucket."
  type        = string

  validation {
    condition     = length(trimspace(var.raw_bucket_name)) >= 3
    error_message = "The raw_bucket_name must contain at least 3 characters."
  }
}

variable "bigquery_dataset_id" {
  description = "BigQuery dataset identifier for D1 Staged/Enforced data."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_]+$", var.bigquery_dataset_id))
    error_message = "The BigQuery dataset ID may contain only letters, numbers, and underscores."
  }
}