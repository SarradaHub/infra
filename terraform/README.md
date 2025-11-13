# Platform Infrastructure as Code

This Terraform stack provisions the shared platform services required by the event-driven ecosystem.

## Components
- **Network Module** (`modules/network`): Creates VPC, public/private subnets across three AZs, NAT gateways, and shared security group.
- **Kafka Module** (`modules/kafka`): Deploys an Amazon MSK cluster with TLS + IAM auth, CloudWatch logging, and optional custom security groups.
- **Schema Registry Module** (`modules/schema_registry`): Manages AWS Glue Schema Registry and seeds canonical event schemas from `platform/contracts`.
- **Observability Module** (`modules/observability`): Creates Amazon Managed Prometheus, Amazon Managed Grafana, shared CloudWatch log groups, and IAM role for OpenTelemetry collectors.
- **Vercel Project Module** (`modules/vercel_project`): Manages frontend deployments, domains, and environment variables via the Vercel provider.
- **Render Service Module** (`modules/render_service`): Provisions API workloads on Render with repository integration and env vars.
- **Supabase Project Module** (`modules/supabase_project`): Maintains Supabase service users and optional SQL post-provision steps.

## Environments
Three environments (`envs/dev`, `envs/staging`, `envs/prod`) reference the shared modules with environment-specific sizing and tagging. Each environment accepts:

- `aws_region`
- `vpc_cidr`
- `public_subnet_cidrs`
- `private_subnet_cidrs`
- `extra_tags`
- `vercel_team_id`
- `vercel_projects`
- `render_services`
- `supabase`

Provider credentials (AWS, Vercel token, Render API key, Supabase personal access token) should be supplied via environment variables prior to running Terraform.

## Usage
```bash
cd infra/terraform/envs/dev
terraform init
terraform plan -out plan.tfplan
terraform apply plan.tfplan
```

Set the `AWS_PROFILE` (and provider tokens) before running Terraform. Replicate the same workflow for `staging` and `prod` directories. The schema registry module reads the JSON schema definitions from `platform/contracts`, ensuring that infrastructure changes stay aligned with published event contracts while SaaS resources stay reproducible.
