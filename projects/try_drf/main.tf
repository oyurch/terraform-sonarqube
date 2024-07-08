module "sonarcloud_project" {
  source               = "../../modules/sonarcloud"
  sonarcloud_api_token = var.sonarcloud_api_token
  organization_key     = var.organization_key
  project_key          = "oyurch_twitter_crawler"
  project_name         = "Twitter Crawler"
  quality_gate_name      = var.quality_gate_name
  group_name           = var.group_name
  permissions           = var.permissions
}