data "aws_cloudfront_cache_policy" "noCache" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "CachingOptimized" {
  name = "Managed-CachingOptimized"
}

data "aws_ssm_parameter" "frontend_listener_arn" {
  name  = "/${var.project_name}/${var.environment_name}/frontend_listener_arn"
}