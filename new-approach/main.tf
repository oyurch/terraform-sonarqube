module "quality_gates" {
  source = "./quality-gates"

  sonarcloud_api_token    = var.sonarcloud_api_token
  sonarcloud_organization = var.sonarcloud_organization
  quality_gates           = var.quality_gates
  projects                = var.projects
}

module "projects" {
  source = "./projects"

  sonarcloud_api_token    = var.sonarcloud_api_token
  sonarcloud_organization = var.sonarcloud_organization
  projects                = var.projects
  quality_gates           = var.quality_gates
}