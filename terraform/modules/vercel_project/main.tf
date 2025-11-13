terraform {
  required_providers {
    vercel = {
      source  = "vercel/vercel"
      version = ">= 1.12.0"
    }
  }
}

resource "vercel_project" "this" {
  name      = var.project_name
  framework = var.framework

  dynamic "git_repository" {
    for_each = var.git_repository == null ? {} : { config = var.git_repository }
    content {
      type = git_repository.value.type
      repo = git_repository.value.repo
    }
  }

  team_id = var.team_id
}

resource "vercel_project_domain" "this" {
  for_each   = toset(var.domains)
  project_id = vercel_project.this.id
  domain     = each.value
  team_id    = var.team_id
}

resource "vercel_project_environment_variable" "this" {
  for_each = var.env_variables

  project_id = vercel_project.this.id
  key        = each.key
  value      = each.value.value
  target     = each.value.target
  type       = lookup(each.value, "type", "encrypted")
  team_id    = var.team_id
}
