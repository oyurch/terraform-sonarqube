module "sonarcloud_project" {
  source               = "../../modules/sonarcloud"
  sonarcloud_api_token = var.sonarcloud_api_token
  organization_key     = var.organization_key
  project_key          = "oyurch_try_drf"
  project_name         = "Try DRF"
  quality_gate_id      = var.quality_gate_id
  group_name           = var.group_name
  permission           = var.permission
  sources              = var.sources
  tests                = var.tests
  coverage_report_paths = var.coverage_report_paths
}