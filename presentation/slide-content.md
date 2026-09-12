# Slide 1 — Project Objective and Context

- Junior Cloud & DevOps Engineer hiring-project submission.
- Covers secure Terraform infrastructure, Poka-Yoke CI controls, and onboarding validation.
- Combines Google Cloud configuration, Django REST Framework, and React/Vite.
- Developed without paid cloud deployment.

**Speaker Notes:** This submission addresses the three assignment areas in one repository. The focus is secure infrastructure design, mistake-proofed delivery controls, and deterministic validation rather than a deployed production environment.

# Slide 2 — Architecture and Data Flow

- React/Vite captures onboarding form data.
- The frontend sends JSON to the Django REST Framework endpoint.
- Django validates and persists `StudentOnboarding` records.
- Terraform defines separate D0 raw-storage and D1 BigQuery data-layer foundations.

**Speaker Notes:** The implemented application path is React to Django, where the model serializer validates incoming data before it is saved. The Terraform resources establish the intended cloud data layers, but the repository does not implement an ingestion or transformation workload between them.

# Slide 3 — Task 1: Terraform Secure Staging Infrastructure

- Requires Terraform 1.6 or later and the Google provider 8.x.
- Defines storage, BigQuery, IAM, Row-Level Security, and App Engine resources.
- Uses variables for the project, region, bucket name, and dataset ID.
- Configuration is defined but not applied.

**Speaker Notes:** Task 1 is implemented as versioned Terraform configuration. It can be formatted and validated locally or in CI, while creation of resources remains an explicit, separate action.

# Slide 4 — D0 Raw Landing and D1 Staged/Enforced

- D0 is a regional Google Cloud Storage raw-landing bucket.
- D0 enables uniform bucket-level access, public-access prevention, versioning, and seven-day soft delete.
- D1 is a regional BigQuery dataset labelled `d1` and `staged-enforced`.
- D1 contains the protected `student_onboarding` table with required string columns.

**Speaker Notes:** D0 is configured as the controlled landing layer for raw incoming data. D1 provides the governed BigQuery foundation, including the table fields used by the onboarding domain.

# Slide 5 — IAM and Least Privilege

- Creates the dedicated `habot-data-pipeline` service account.
- Grants `roles/storage.objectCreator` on the D0 bucket.
- Avoids object-administration permissions in the configured binding.
- `RawLandingBucketOnly` limits access to the D0 object resource path.

**Speaker Notes:** The pipeline identity has a narrow, purpose-specific storage role instead of broad object administration. The IAM condition adds a resource-path restriction to the binding.

# Slide 6 — BigQuery Row-Level Security

- `organization_id` is the `student_onboarding` row-security boundary.
- Terraform creates the `student_onboarding_principal_access` policy.
- The policy filter is `organization_id = SESSION_USER()`.
- The configured policy grantee is `allAuthenticatedUsers`.

**Speaker Notes:** The row access policy evaluates the authenticated BigQuery principal for the current session. It returns only rows whose `organization_id` equals that session value, as expressed by the current Terraform configuration.

# Slide 7 — Task 2: Poka-Yoke CI/CD Pipeline

- GitHub Actions runs on pushes and pull requests targeting `main`.
- Terraform formatting, initialization, and validation are required gates.
- YAML linting and Gitleaks secret scanning are required gates.
- The workflow uses a single quality-and-security job.

**Speaker Notes:** This is a Poka-Yoke gate: required quality and security checks are placed before a change can reach the workflow's success confirmation. The checks cover both infrastructure correctness and common repository hygiene risks.

# Slide 8 — Fail-Closed Behavior and Secret Scanning

- A failed required step stops the GitHub Actions job.
- The final success confirmation is not reached after a failed gate.
- Gitleaks scans for committed secrets and credentials.
- CI documentation records a successful run with no detected leaks.

**Speaker Notes:** The workflow relies on failing step status to stop progression, which is the fail-closed behavior. The repository documentation records a successful CI execution and a Gitleaks result with no detected leaks.

# Slide 9 — Task 3: Incoming JSON and DCYN Validation

- DCYN is implemented by the reusable `normalize_yes_no()` function.
- It accepts strings, trims whitespace, and compares case-insensitively.
- `Yes` normalizes to `True`; `No` normalizes to `False`.
- Other values and non-string inputs raise `ValueError`.

**Speaker Notes:** DCYN provides a deterministic binary normalization rule for standalone Yes/No values. It intentionally accepts only the two normalized values, making invalid input explicit rather than ambiguous.

# Slide 10 — Django REST Framework API and Serializer Validation

- `POST /api/student-onboarding/` accepts onboarding requests.
- Valid requests are saved and return HTTP 201.
- Invalid serializer data returns HTTP 400.
- The model serializer enforces required fields and model maximum lengths.

**Speaker Notes:** The API uses `StudentOnboardingSerializer` for request validation and persistence. Its current validation is model-derived; it has no status allowlist or custom cross-field validation.

# Slide 11 — React Frontend and API Integration

- React/Vite provides a form for the four onboarding fields.
- The form sends JSON to `/api/student-onboarding/`.
- The UI displays acceptance, validation-failure, or request-failure messages.
- The Vite development proxy routes `/api` to `http://127.0.0.1:8000`.

**Speaker Notes:** The frontend demonstrates the integration point with the Django API. It uses the same field names as the API and delegates server-side validation to Django REST Framework.

# Slide 12 — Testing and Validation Evidence

- Django tests are implemented for DCYN, `YesNoField`, serializer validation, and API responses.
- The test suite includes valid and invalid onboarding request cases.
- The Django test execution result is not claimed here.
- `npm run lint` completed successfully in the current workspace.

**Speaker Notes:** The repository includes automated Django coverage for the validation behaviors shown in this presentation. Because a successful Django test execution was not verified in the current environment, the tests are described as implemented rather than passed; the frontend lint result was successfully verified.

# Slide 13 — Security Decisions and Mistake-Proofing

- D0 blocks public access and centralizes access with bucket-level controls.
- The pipeline identity receives a narrowly scoped storage role and condition.
- BigQuery row access is filtered by `organization_id` and `SESSION_USER()`.
- CI blocks progression when required quality or security gates fail.

**Speaker Notes:** Security controls are applied at the storage, identity, data-access, and delivery stages. Together, these decisions reduce accidental exposure, over-privileged access, and silent acceptance of invalid changes.

# Slide 14 — Limitations and Assignment Caveats

- The assignment did not provide the Task 3 incoming JSON payload.
- The assignment did not provide exact Task 3 validation limits.
- Field names, lengths, sample payloads, and frontend status options are implementation choices.
- No production Pub/Sub-to-BigQuery streaming pipeline is implemented.

**Speaker Notes:** The current schema and validation limits are deliberately not represented as assignment-provided facts. The repository provides a schema and data-layer foundation, not a production streaming pipeline.

# Slide 15 — Deployment Posture and Conclusion

- No Google Cloud resources were created for this submission.
- Terraform checks validate configuration; they do not provision resources.
- Deployment would require a configured Google Cloud project and explicit `terraform apply`.
- The submission demonstrates secure design, fail-closed automation, and validation foundations.

**Speaker Notes:** The final posture is intentionally configuration-first and cost-conscious. The project demonstrates the requested foundations while preserving the distinction between validated code and an actual cloud deployment.
