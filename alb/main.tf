resource "aws_lb" "main" {
  count = var.create_lb ? 1 : 0

  name        = var.name
  name_prefix = var.name_prefix

  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  security_groups    = var.security_groups
  subnets            = var.subnets

  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = var.enable_http2
  ip_address_type                  = var.ip_address_type
  drop_invalid_header_fields       = var.drop_invalid_header_fields
  preserve_host_header             = var.preserve_host_header
  enable_waf_fail_open             = var.enable_waf_fail_open
  desync_mitigation_mode           = var.desync_mitigation_mode

  dynamic "access_logs" {
    for_each = length(keys(var.access_logs)) == 0 ? [] : [var.access_logs]

    content {
      enabled = try(access_logs.value.enabled, try(access_logs.value.bucket, null) != null)
      bucket  = try(access_logs.value.bucket, null)
      prefix  = try(access_logs.value.prefix, null)
    }
  }

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping

    content {
      subnet_id            = subnet_mapping.value.subnet_id
      allocation_id        = lookup(subnet_mapping.value, "allocation_id", null)
      private_ipv4_address = lookup(subnet_mapping.value, "private_ipv4_address", null)
      ipv6_address         = lookup(subnet_mapping.value, "ipv6_address", null)
    }
  }

  tags = merge(
    {
      Name = (var.name != null) ? var.name : var.name_prefix
    },
    var.tags,
    var.lb_tags,
  )

  timeouts {
    create = var.load_balancer_create_timeout
    update = var.load_balancer_update_timeout
    delete = var.load_balancer_delete_timeout
  }
}

resource "aws_lb_target_group" "main" {
  count = var.create_lb ? 1 : 0

  name     = "${var.name}-tg"
  name_prefix = var.name_prefix

  port     = var.port
  protocol = var.protocol
  target_type = var.target_type
  vpc_id   = var.vpc_id

  connection_termination = var.connection_termination
  deregistration_delay = var.deregistration_delay
  slow_start                         = var.slow_start
  proxy_protocol_v2                  = var.proxy_protocol_v2
  lambda_multi_value_headers_enabled = var.lambda_multi_value_headers_enabled
  load_balancing_algorithm_type      = var.load_balancing_algorithm_type
  preserve_client_ip                 = var.preserve_client_ip
  ip_address_type                    = var.tg_ip_address_type


  dynamic "health_check" {
    for_each = (var.health_check == !null ? var.health_check : null)
    content {
      enabled             = lookup(health_check.value, "enabled", null)
      interval            = lookup(health_check.value, "interval", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      timeout             = lookup(health_check.value, "timeout", null)
      protocol            = lookup(health_check.value, "protocol", null)
      matcher             = lookup(health_check.value, "matcher", null)
    }
  }
  dynamic "stickiness" {
    for_each = (var.stickiness == !null ? var.stickiness : null)
    content {
      enabled         = lookup(stickiness.value, "enabled", null)
      cookie_duration = lookup(stickiness.value, "cookie_duration", null)
      type            = lookup(stickiness.value, "type", null)
      cookie_name     = lookup(stickiness.value, "cookie_name", null)
    }
  }

  tags = merge(
    var.tags,
    var.target_group_tags,
    {
      "Name" = var.name
    },
  )

  lifecycle {
    create_before_destroy = true
  }

}

