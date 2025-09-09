# resource "aws_wafv2_web_acl" "waf-url-shortener" {
#   name        = "managed-rule-example"
#   description = "Example of a managed rule."
#   scope       = "REGIONAL"
#   region      = "eu-north-1"

#   default_action {
#     allow {}
#   }

#   rule {
#     name     = "rule-1"
#     priority = 1

#     override_action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesCommonRuleSet"
#         vendor_name = "AWS"

#         rule_action_override {
#           action_to_use {
#             count {}
#           }

#           name = "SizeRestrictions_QUERYSTRING"
#         }

#         rule_action_override {
#           action_to_use {
#             count {}
#           }

#           name = "NoUserAgent_HEADER"
#         }

#         scope_down_statement {
#           geo_match_statement {
#             country_codes = ["US", "NL"]
#           }
#         }
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = false
#       metric_name                = "friendly-rule-metric-name"
#       sampled_requests_enabled   = false
#     }
#   }

#   visibility_config {
#     cloudwatch_metrics_enabled = false
#     metric_name                = "friendly-metric-name"
#     sampled_requests_enabled   = false
#   }

#   tags = {
#     Name = "waf for url-shortener app"
#   }
# }


# resource "aws_wafv2_web_acl_association" "example" {
#   resource_arn = var.load_balancer_arn
#   web_acl_arn  = aws_wafv2_web_acl.example.arn
# }