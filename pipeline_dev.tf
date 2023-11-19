# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_codebuild_project" "codedbuild_dev" {
  badge_enabled          = false
  build_timeout          = 10
  concurrent_build_limit = 1
  description            = null
  encryption_key         = "arn:aws:kms:us-west-1:021427789578:alias/aws/s3"
  name                   = "js30-build"
  project_visibility     = "PRIVATE"
  queued_timeout         = 480
  resource_access_role   = null
  service_role           = "arn:aws:iam::021427789578:role/service-role/codebuild-js30-build-service-role"
  source_version         = null
  tags                   = {}
  tags_all               = {}
  artifacts {
    artifact_identifier    = null
    bucket_owner_access    = null
    encryption_disabled    = false
    location               = null
    name                   = "js30-build"
    namespace_type         = null
    override_artifact_name = false
    packaging              = "NONE"
    path                   = null
    type                   = "CODEPIPELINE"
  }
  cache {
    location = null
    modes    = []
    type     = "NO_CACHE"
  }
  environment {
    certificate                 = null
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }
  logs_config {
    cloudwatch_logs {
      group_name  = null
      status      = "DISABLED"
      stream_name = null
    }
    s3_logs {
      bucket_owner_access = null
      encryption_disabled = true
      location            = "common-logs-metax7-sandbox-mbc/js30/dev/pipeline"
      status              = "ENABLED"
    }
  }
  source {
    buildspec           = "buildspec-dev.yml"
    git_clone_depth     = 0
    insecure_ssl        = false
    location            = null
    report_build_status = false
    type                = "CODEPIPELINE"
  }
}

# __generated__ by Terraform from "js30-pipeline"
resource "aws_codepipeline" "pipeline_dev" {
  name     = "js30-pipeline"
  role_arn = "arn:aws:iam::021427789578:role/service-role/AWSCodePipelineServiceRole-us-west-1-js30-pipeline"
  tags     = {}
  tags_all = {}
  artifact_store {
    location = "codepipeline-us-west-1-745705218384"
    region   = null
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      category = "Source"
      configuration = {
        BranchName           = "main"
        ConnectionArn        = "arn:aws:codestar-connections:us-east-1:021427789578:connection/c0f23fdb-0930-40e0-8535-610b04bf0042"
        DetectChanges        = "true"
        FullRepositoryId     = "Metax7/JS30"
        OutputArtifactFormat = "CODE_ZIP"
      }
      input_artifacts  = []
      name             = "Source"
      namespace        = "SourceVariables"
      output_artifacts = ["SourceArtifact"]
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      region           = "us-west-1"
      role_arn         = null
      run_order        = 1
      version          = "1"
    }
  }
  stage {
    name = "BUILD_vite_DEPLOY_s3"
    action {
      category = "Build"
      configuration = {
        ProjectName = "js30-build"
      }
      input_artifacts  = ["SourceArtifact"]
      name             = "build"
      namespace        = null
      output_artifacts = []
      owner            = "AWS"
      provider         = "CodeBuild"
      region           = "us-west-1"
      role_arn         = null
      run_order        = 1
      version          = "1"
    }
  }
}
