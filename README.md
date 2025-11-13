# Infra Overview

The `infra` project centralizes infrastructure as code used to provision shared services for SarradaHub. It focuses on repeatable environments, secure network foundations, and the external platforms that support the product suite.

## Structure

- `terraform`: Terraform configuration for core networking, event streaming, observability, and integrations with providers such as Vercel, Render, and Supabase. Environment directories under `terraform/envs` hold deployment specific variables while modules capture reusable building blocks.

## Operating Guidelines

- Keep provider credentials out of the repository and load them through environment variables before running Terraform commands.
- When introducing a new shared capability, add a Terraform module and document it in `terraform/README.md`.
- Use the same review process as application code, including plan output for every pull request that changes infrastructure.

