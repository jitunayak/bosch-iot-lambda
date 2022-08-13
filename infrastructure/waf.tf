resource "aws_wafv2_web_acl" "waf" {
  name  = "waf-bosch-iot"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-allow-based-geography"
    priority = 1
    action {
      allow {}
    }

    statement {
      geo_match_statement {
        country_codes = ["IN"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "rule-apigatway-matric"
      sampled_requests_enabled   = false
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "bosch-iot-apigatway-matric"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "this" {
  resource_arn = aws_api_gateway_stage.stage.arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}

