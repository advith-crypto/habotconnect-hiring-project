# Task 3 — Data Schema and DCYN Validation

## Objective

Task 3 requires the incoming student onboarding JSON payload to be
deconstructed into a binary Yes/No logic library and validated through
Django REST Framework.

## Confirmed Requirements

The assignment requires:

- Deconstruction of the incoming JSON onboarding payload.
- Binary Yes/No logic using the DCYN library.
- A Django REST Framework model serializer.
- Exact field validation limits.
- Data validation before downstream processing.

## Information Available in the Assignment

The supplied assignment document does not contain the actual incoming
JSON payload.

The supplied assignment document also does not define the exact field
names, data types, or validation limits for that payload.

Therefore, those values are not invented in this implementation.

## Current Validation Foundation

The repository contains a reusable DCYN function:

```text
normalize_yes_no()