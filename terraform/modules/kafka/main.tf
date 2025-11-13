terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

resource "aws_security_group" "kafka" {
  name        = "${var.cluster_name}-sg"
  description = "Security group for MSK cluster"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Broker to broker communication"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    self             = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    "Name" = "${var.cluster_name}-sg"
  })
}

locals {
  client_sg_ids = concat([aws_security_group.kafka.id], var.security_group_ids)
}

resource "aws_msk_cluster" "this" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    client_subnets  = var.subnet_ids
    security_groups = local.client_sg_ids
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }

    dynamic "encryption_at_rest" {
      for_each = var.encryption_kms_key_arn == null ? [] : [var.encryption_kms_key_arn]
      content {
        data_volume_kms_key_id = encryption_at_rest.value
      }
    }
  }

  enhanced_monitoring = var.monitoring_prometheus ? "PER_TOPIC_PER_PARTITION" : "DEFAULT"

  client_authentication {
    sasl {
      iam = true
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = "/platform/msk/${var.cluster_name}"
      }
    }
  }

  tags = var.tags
}
