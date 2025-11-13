terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

resource "aws_prometheus_workspace" "this" {
  alias = var.amp_workspace_alias
  tags  = var.tags
}

resource "aws_grafana_workspace" "this" {
  account_access_type = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  name                       = var.grafana_workspace_name
  data_sources               = ["PROMETHEUS"]
  permission_type            = "SERVICE_MANAGED"
  tags                       = var.tags
}

resource "aws_cloudwatch_log_group" "shared" {
  for_each          = toset(var.log_group_names)
  name              = each.value
  retention_in_days = 30
  tags              = var.tags
}

resource "aws_iam_role" "otlp_collector" {
  name               = "platform-otel-collector"
  assume_role_policy = data.aws_iam_policy_document.otlp_assume.json
  tags               = var.tags
}

data "aws_iam_policy_document" "otlp_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "otlp" {
  name   = "platform-otel-collector-policy"
  role   = aws_iam_role.otlp_collector.id
  policy = data.aws_iam_policy_document.otlp_policy.json
}

data "aws_iam_policy_document" "otlp_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [for lg in aws_cloudwatch_log_group.shared : "${lg.arn}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "aps:RemoteWrite",
      "aps:QueryMetrics"
    ]
    resources = [aws_prometheus_workspace.this.arn]
  }
}

resource "aws_cloudwatch_metric_alarm" "managed" {
  for_each            = { for alarm in var.metric_alarms : alarm.name => alarm }
  alarm_name          = each.value.name
  namespace           = each.value.namespace
  metric_name         = each.value.metric_name
  statistic           = each.value.statistic
  period              = each.value.period
  evaluation_periods  = each.value.evaluation_periods
  threshold           = each.value.threshold
  comparison_operator = each.value.comparison_operator
  datapoints_to_alarm = try(each.value.datapoints_to_alarm, null)
  treat_missing_data  = try(each.value.treat_missing_data, "missing")
  alarm_description   = try(each.value.alarm_description, "")
  dimensions          = try(each.value.dimensions, {})
  tags                = var.tags
}
