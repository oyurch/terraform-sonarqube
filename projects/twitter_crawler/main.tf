module "sonarcloud_project" {
  source             = "../../modules/sonarcloud"
  sonarcloud_api_token = var.sonarcloud_api_token
  organization_key     = var.organization_key
  project_key          = var.project_key
  project_name         = var.project_name
  quality_gate_id      = var.quality_gate_id
  group_name           = var.group_name
  permission           = var.permission
}