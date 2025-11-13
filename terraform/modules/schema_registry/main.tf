terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

resource "aws_glue_registry" "this" {
  registry_name = var.registry_name
  description   = var.description
  tags          = var.tags
}

resource "aws_glue_schema" "this" {
  for_each       = var.schemas
  schema_name    = each.key
  registry_arn   = aws_glue_registry.this.arn
  data_format    = lookup(each.value, "data_format", "JSON")
  compatibility  = lookup(each.value, "compatibility", var.compatibility)
  schema_version = 1
  description    = lookup(each.value, "description", "")
  schema_definition = each.value.schema_def

  tags = var.tags
}
