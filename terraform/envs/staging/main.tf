terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    vercel = {
      source  = "vercel/vercel"
      version = ">= 1.12.0"
    }
    render = {
      source  = "render-oss/render"
      version = ">= 1.4.1"
    }
    supabase = {
      source  = "supabasehq/supabase"
      version = ">= 0.11.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "vercel" {
  team = var.vercel_team_id
}

provider "render" {}

provider "supabase" {}

module "network" {
  source               = "../../modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = local.tags
}

module "kafka" {
  source                 = "../../modules/kafka"
  cluster_name           = "platform-events-staging"
  kafka_version          = "3.7.0"
  number_of_broker_nodes = 3
  broker_instance_type   = "kafka.m7g.xlarge"
  subnet_ids             = module.network.private_subnet_ids
  security_group_ids     = module.network.shared_security_group_ids
  vpc_id                 = module.network.vpc_id
  tags                   = local.tags
}

module "schema_registry" {
  source        = "../../modules/schema_registry"
  registry_name = "platform-events-staging"
  tags          = local.tags
  schemas = {
    for name, path in local.schema_files : name => {
      description = "${name} schema"
      schema_def  = file(path)
    }
  }
}

module "observability" {
  source                 = "../../modules/observability"
  grafana_workspace_name = "platform-grafana-staging"
  amp_workspace_alias    = "platform-events-staging"
  tags                   = local.tags
  metric_alarms = [
    {
      name                = "staging-kafka-active-controller"
      metric_name         = "ActiveControllerCount"
      namespace           = "AWS/Kafka"
      statistic           = "Minimum"
      period              = 300
      evaluation_periods  = 1
      threshold           = 1
      comparison_operator = "LessThanThreshold"
      dimensions          = { ClusterArn = module.kafka.cluster_arn }
      alarm_description   = "Kafka controller count dropped below 1 (staging)"
    }
  ]
}

module "vercel_project" {
  for_each        = var.vercel_projects
  source          = "../../modules/vercel_project"
  project_name    = each.key
  framework       = each.value.framework
  git_repository  = each.value.git_repository
  env_variables   = each.value.env_variables
  domains         = each.value.domains
  team_id         = var.vercel_team_id
}

module "render_service" {
  for_each       = var.render_services
  source         = "../../modules/render_service"
  name           = each.key
  service_type   = each.value.service_type
  repo           = each.value.repo
  env_vars       = each.value.env_vars
  plan           = lookup(each.value, "plan", "starter")
  region         = lookup(each.value, "region", "oregon")
  runtime        = lookup(each.value, "runtime", "node")
  build_command  = lookup(each.value, "build_command", "npm install && npm run build")
  start_command  = lookup(each.value, "start_command", "npm run start")
}

module "supabase" {
  count             = var.supabase == null ? 0 : 1
  source            = "../../modules/supabase_project"
  project_id        = var.supabase.project_id
  database_password = var.supabase.database_password
  sql               = try(var.supabase.sql, [])
}

locals {
  tags = merge(
    {
      "Environment" = "staging"
      "Project"     = "platform-events"
    },
    var.extra_tags
  )

  schema_files = {
    "user-created"                = "../../../../platform/contracts/schemas/identity/user.created.v1.json"
    "match-scheduled"             = "../../../../platform/contracts/schemas/scheduling/match.scheduled.v1.json"
    "bet-market-created"          = "../../../../platform/contracts/schemas/betting/bet.market.created.v1.json"
    "wager-accepted"              = "../../../../platform/contracts/schemas/betting/wager.accepted.v1.json"
    "payment-received"            = "../../../../platform/contracts/schemas/finance/payment.received.v1.json"
    "ledger-transaction-recorded" = "../../../../platform/contracts/schemas/ledger/ledger.transaction.recorded.v1.json"
  }
}
