# Terraform Infrastructure

## Purpose

This Terraform configuration defines the Google Cloud infrastructure
required for the HabotConnect data pipeline staging architecture.

The configuration is designed for secure, repeatable infrastructure
provisioning and follows a least-privilege approach.

## Data Layers

### D0 — Raw Landing

Google Cloud Storage is used as the raw landing layer for incoming data.

Security controls include:

- Uniform bucket-level access
- Public access prevention
- Object versioning
- Soft-delete retention

### D1 — Staged/Enforced

BigQuery is used as the staged and enforced data layer.

The dataset is configured for governed downstream processing and analytics.

## Identity and Access Management

A dedicated service account is defined for the data pipeline.

The pipeline receives bucket-level object permissions rather than broad
project-level permissions.

An IAM condition restricts the object permission to the D0 Raw Landing
bucket.

## Validation

Terraform configuration should be formatted and validated before any
deployment operation.

```text
terraform fmt
terraform validate