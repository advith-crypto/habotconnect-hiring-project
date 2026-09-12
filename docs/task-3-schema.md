# Task 3: schema mapping and DCYN validation

## Assignment scope and implementation choices

The assignment explicitly calls for schema mapping, deterministic binary Yes/No (DCYN) validation, a Django REST Framework model serializer, and validation before downstream processing. It does not provide the incoming JSON payload or exact field validation limits. Accordingly, the fields, field lengths, and status values below describe the current implementation choices; they are not presented as missing assignment requirements.

## Current onboarding schema

`StudentOnboarding` is stored in the `student_onboarding` table. Django supplies its default `id` primary key (`BigAutoField`). The onboarding fields are all required `CharField` values:

| Field | Maximum length |
| --- | ---: |
| `student_id` | 100 |
| `organization_id` | 255 |
| `student_name` | 255 |
| `onboarding_status` | 50 |

`StudentOnboardingSerializer` exposes these four onboarding fields. As a model serializer, it applies the model-derived required-field and maximum-length validation. It does not define a permitted set of `onboarding_status` values, custom cross-field validation, or a DCYN field.

## DCYN normalization

`normalize_yes_no(value)` accepts a string, trims surrounding whitespace, and compares it case-insensitively. Only `yes` and `no` are accepted: values such as `"Yes"` and `"  YES  "` return `True`; `"No"` and `" no "` return `False`. A non-string value raises `ValueError` stating that a string containing Yes or No is required; any other string raises `ValueError` stating that the value must be exactly Yes or No.

`YesNoField` is a reusable DRF `CharField` that calls this function during deserialization. Its internal validated value is a Boolean, and a normalization failure becomes a DRF field validation error. It is currently tested independently and is not used by `StudentOnboardingSerializer`.

## API endpoint

`POST /api/student-onboarding/` validates the request with `StudentOnboardingSerializer`. Valid data is saved and returned with HTTP 201; serializer errors are returned with HTTP 400. Because the endpoint uses the model serializer, its current request validation is the required-field and maximum-length validation described above, not DCYN normalization.

## Automated validation coverage

The test suite verifies:

- DCYN conversion of Yes and No, case/whitespace normalization, and rejection of `"Maybe"`.
- `YesNoField` conversion to Boolean `True`/`False` and serializer rejection of `"Maybe"`.
- acceptance of a complete `StudentOnboardingSerializer` payload and rejection when `onboarding_status` is omitted.
- HTTP 201 for a complete onboarding API request and HTTP 400 with an `onboarding_status` error when that field is omitted.

The example onboarding payload and the model's field limits are implementation choices made in the absence of an assignment-supplied payload and exact validation limits.
