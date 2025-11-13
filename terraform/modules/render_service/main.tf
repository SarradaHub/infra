terraform {
  required_providers {
    render = {
      source  = "render-oss/render"
      version = ">= 1.4.1"
    }
  }
}

resource "render_service" "this" {
  name         = var.name
  type         = var.service_type
  plan         = var.plan
  region       = var.region
  repo         = "${var.repo.owner}/${var.repo.name}"
  branch       = var.repo.branch
  runtime      = var.runtime
  build_command = var.build_command
  start_command = var.start_command

  env = [for k, v in var.env_vars : {
    key   = k
    value = v
  }]
}
