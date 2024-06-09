data "aws_ssm_parameter" "acm_certificate_arn" {
  name = "/${var.project_name}/${var.environment}/acm_certificate_arn"
}

## these are directly get from AWS by simply giving name
data "aws_cloudfront_cache_policy" "cache_enable" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "cache_disable" {
  name = "Managed-CachingDisabled"
}