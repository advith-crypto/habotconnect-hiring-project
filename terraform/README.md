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

The dedicated data pipeline identity receives the
`roles/storage.objectCreator` role rather than object administration
permissions. This prevents the ingestion identity from modifying or
deleting existing objects.

### D1 — Staged/Enforced

BigQuery is used as the staged and enforced data layer.

The `student_onboarding` table contains:

- `student_id`
- `organization_id`
- `student_name`
- `onboarding_status`

The table has deletion protection enabled.

## Row-Level Security

BigQuery Row-Level Security is applied to the
`student_onboarding` table.

The policy uses:

```text
organization_id = SESSION_USER()