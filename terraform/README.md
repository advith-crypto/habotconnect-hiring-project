# Terraform infrastructure

This directory defines the intended Google Cloud foundation for the HabotConnect data pipeline. It is developed and validated without a paid deployment: no Google Cloud resources are created from this project unless Terraform is explicitly initialized, planned, and applied in a configured Google Cloud project.

## Data layers and controls

- **D0 Raw Landing** is a Google Cloud Storage bucket. It uses uniform bucket-level access, enforced public-access prevention, object versioning, and a seven-day soft-delete retention policy.
- **D1 Staged/Enforced** is a regional BigQuery dataset labelled as `data_layer = d1` and `environment = staged-enforced`. Terraform is configured not to delete its contents during destroy.
- The D1 `student_onboarding` table has required `student_id`, `organization_id`, `student_name`, and `onboarding_status` string fields. Deletion protection is enabled. `organization_id` is the row-level security boundary.

## BigQuery row-level security

Terraform creates the `student_onboarding_principal_access` row access policy on `student_onboarding`. It is granted to `allAuthenticatedUsers` and filters rows with:

```text
organization_id = SESSION_USER()
```

Consequently, the policy returns only rows whose `organization_id` equals the authenticated BigQuery principal for that session.

## Pipeline identity and storage access

The configuration creates the dedicated `habot-data-pipeline` service account for ingestion. Its configured storage access is limited to `roles/storage.objectCreator` on the D0 bucket, rather than object-administration permissions. An IAM condition named `RawLandingBucketOnly` further restricts that binding to object resource names beginning with the configured D0 bucket's `objects/` path.

## App Engine

Terraform also defines an App Engine application in the configured project and region, with `CLOUD_FIRESTORE` as its database type.

## Local checks

From this directory, use Terraform 1.6 or later with the HashiCorp Google provider 8.x:

```powershell
terraform fmt -check -recursive .
terraform init -backend=false
terraform validate
```

These commands format-check and validate the configuration only; they do not create resources. A real deployment would require explicit Google Cloud project configuration and a separate `terraform apply`, neither of which is performed for this hiring project.
