module "twitter_crawler" {
  source               = "../../projects/twitter_crawler"
  sonarcloud_api_token  = var.sonarcloud_api_token
  organization_key      = var.organization_key
  quality_gate_id       = var.quality_gate_id
  group_name            = var.group_name
  permission            = var.permission
}

module "try_drf" {
  source               = "../../projects/try_drf"
  sonarcloud_api_token  = var.sonarcloud_api_token
  organization_key      = var.organization_key
  quality_gate_id       = var.quality_gate_id
  group_name            = var.group_name
  permission            = var.permission
}
