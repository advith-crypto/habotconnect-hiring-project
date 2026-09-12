# HabotConnect Junior Cloud & DevOps Engineer hiring project

This submission implements the three assignment areas: secure Terraform staging infrastructure, a Poka-Yoke CI security gate, and Django/React onboarding validation. It was developed and validated without paid cloud deployment. No Google Cloud resources have been created from this project.

## Assignment coverage

1. **Terraform secure staging provisioning** — an infrastructure definition for the data pipeline and application foundation.
2. **Poka-Yoke automated CI/CD build gate** — fail-closed formatting, validation, linting, and secret-scanning controls.
3. **Schema mapping and DCYN validation** — a Django REST Framework onboarding API, deterministic Yes/No normalization, and a React form.

## Repository layout

```text
.
├── .github/workflows/ci.yml  # Poka-Yoke quality and security gate
├── terraform/                # Google Cloud infrastructure definitions
├── django/                   # Django project and onboarding API
├── frontend/                 # React/Vite onboarding client
├── docs/                     # Task and CI documentation
└── requirements.txt          # Django and DRF dependencies
```

## Terraform infrastructure

The Terraform configuration targets Google provider 8.x with Terraform 1.6 or later. It defines, but does not apply:

- **D0 Raw Landing:** a regional Google Cloud Storage bucket with uniform bucket-level access, enforced public-access prevention, object versioning, and a seven-day soft-delete retention policy.
- **D1 Staged/Enforced:** a regional BigQuery dataset and the `student_onboarding` table. The table has required string `student_id`, `organization_id`, `student_name`, and `onboarding_status` columns, with deletion protection enabled. `organization_id` is the row-level security boundary.
- **IAM:** a dedicated `habot-data-pipeline` service account with `roles/storage.objectCreator` on the D0 bucket. The `RawLandingBucketOnly` IAM condition limits the binding to that bucket's object resource path.
- **BigQuery RLS:** the `student_onboarding_principal_access` policy is granted to `allAuthenticatedUsers` and filters with `organization_id = SESSION_USER()`.
- **App Engine:** a regional application configured with `CLOUD_FIRESTORE` as its database type.

## Poka-Yoke CI security gate

GitHub Actions runs on pushes and pull requests targeting `main`. The required gates are Terraform formatting, `terraform init -backend=false`, Terraform validation, YAML linting, and Gitleaks secret scanning. The job is fail-closed: a failed required step stops the job, so its final success confirmation is not reached.

The repository's CI documentation records a successful GitHub Actions run and a Gitleaks result with no detected leaks. The frontend's configured `npm run lint` check also completed successfully in this workspace.

## Onboarding API and DCYN validation

`POST /api/student-onboarding/` accepts the four onboarding fields through `StudentOnboardingSerializer`, saves valid requests, and returns HTTP 201. Invalid serializer data returns HTTP 400. The model serializer applies required-field and maximum-length validation from the model; it does not constrain `onboarding_status` to a fixed set or include custom cross-field validation.

`normalize_yes_no()` accepts strings only, trims whitespace, and compares case-insensitively. `Yes` normalizes to `True` and `No` to `False`; other values and non-strings raise `ValueError`. The reusable DRF `YesNoField` converts those failures into field validation errors and returns a Boolean internal value. It is tested independently and is not currently attached to a `StudentOnboardingSerializer` field.

The automated Django tests cover DCYN normalization and rejection, `YesNoField` Boolean conversion and rejection, serializer required-field validation, and successful/invalid API requests.

The Task 3 assignment did not provide the actual incoming JSON payload or exact validation limits. The current field names, lengths, example status values, and sample payloads are therefore implementation choices, not claims about assignment-provided requirements.

## React frontend

The React/Vite client provides an onboarding form for the same four fields. It submits JSON to `/api/student-onboarding/`, displays accepted or validation-failure messages, and uses the Vite development proxy to route `/api` requests to `http://127.0.0.1:8000`.

## Local validation

Run the following from the repository root as needed:

```powershell
# Terraform (does not create resources)
Set-Location terraform
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
Set-Location ..

# Django API tests
python -m pip install -r requirements.txt
Set-Location django
python manage.py test onboarding
Set-Location ..

# React checks
Set-Location frontend
npm ci
npm run lint
npm run build
```

Creating cloud resources requires separately supplying a Google Cloud project configuration and explicitly running `terraform apply`; neither is part of this submission's validation process.
