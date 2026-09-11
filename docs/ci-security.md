# Poka-Yoke CI Security Gate

## Purpose

The continuous integration pipeline is designed as a fail-closed
quality and security gate.

A change must pass all required checks before it is considered eligible
to continue through the pipeline.

## Automated Gates

The pipeline performs the following checks:

1. Terraform formatting validation
2. Terraform configuration validation
3. YAML linting
4. Secret and credential scanning with Gitleaks
5. Explicit fail-closed confirmation

## Fail-Closed Behavior

Each required check is executed as a pipeline step.

If a required check returns a failure status, GitHub Actions stops the
job and the final success confirmation is not reached.

This prevents non-compliant changes from silently progressing.

## Secret Protection

The secret scanning gate is designed to detect credentials and
hardcoded secrets committed to the repository.

Credentials must not be stored directly in source code.

## Successful Verification

The pipeline has been executed through GitHub Actions and completed
successfully.

The security scan reported that no leaks were detected.

## Local Validation

The YAML configuration was also validated locally using:

```text
python -m yamllint .