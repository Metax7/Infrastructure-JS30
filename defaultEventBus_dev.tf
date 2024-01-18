
# __generated__ by Terraform from "default/TriggerLambdaIfCipherKeyNotChanged/Id24735f1b-725d-4201-a3fe-4c984368d856"
resource "aws_cloudwatch_event_target" "TriggerKeyRotationLambda_dev" {
  arn            = aws_lambda_function.rotateKeyMaterialDev.arn
  event_bus_name = "default"
  rule           = aws_cloudwatch_event_rule.CaptureNoChangeNotificationSSM_cipherkey_dev.name
  target_id      = "Id24735f1b-725d-4201-a3fe-4c984368d856"
  retry_policy {
    maximum_event_age_in_seconds = 0
    maximum_retry_attempts       = 3
  }
}

# __generated__ by Terraform from "default/TriggerLambdaIfCipherKeyNotChanged"
resource "aws_cloudwatch_event_rule" "CaptureNoChangeNotificationSSM_cipherkey_dev" {
  description    = "Capture NoChangeNotification published by ${local.rtckc_name} SSM Parameter"
  event_bus_name = "default"
  event_pattern  = "{\"detail\":{\"policy-type\":[\"NoChangeNotification\"]},\"detail-type\":[\"Parameter Store Policy Action\"],\"source\":[\"aws.ssm\"]}"
  name           = "TriggerLambdaIfCipherKeyNotChanged"
  state          = "ENABLED"
  tags = {
    CreatedBy = "manually"
  }
  tags_all = {
    CreatedBy = "manually"
  }
}
