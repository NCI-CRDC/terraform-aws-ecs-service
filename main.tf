resource "aws_ecs_service" "this" {
  name                               = "${local.stack}-${var.resource_name_suffix}"
  cluster                            = var.cluster
  task_definition                    = var.task_definition
  launch_type                        = var.launch_type
  scheduling_strategy                = var.scheduling_strategy
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent


  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${local.stack}-${var.container_name}"
    container_port   = var.container_port
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = var.security_groups
    subnets          = var.subnets
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}


variable "cluster" {
  type        = string
  description = "id of the cluster associated with the service"
}

variable "desired_count" {
  type        = number
  description = "desired number of containers for the service to run"
  default     = 1
}

variable "deployment_maximum_percent" {
  type        = number
  description = "upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment"
  default     = 500
}

variable "deployment_minimum_healthy_percent" {
  type        = number
  description = "lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment"
  default     = 100
}

variable "launch_type" {
  type        = string
  description = "launch type of the service - either EC2, FARGATE, or EXTERNAL"
  default     = "FARGATE"
}

variable "scheduling_strategy" {
  type        = string
  description = ""
  default     = "REPLICA"
}

variable "security_groups" {
  type        = set(string)
  description = "arns of the security groups to attach to ecs services"
}

variable "subnets" {
  type        = set(string)
  description = "ids of the target subnets for the ecs deployment"
}

variable "task_definition" {
  value       = string
  description = "arn of the task definition associated with the service"
}

