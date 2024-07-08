terraform {
  required_providers {
    sonarcloud = {
      source  = "rewe-digital/sonarcloud"
      version = "0.1.1"
    }
  }
}

provider "sonarcloud" {
  organization = var.organization_key
  token        = var.sonarcloud_api_token
}

resource "sonarcloud_project" "project" {
  name         = var.project_name
  project_key  = var.project_key
  visibility   = "public"  # or "private" based on your requirements
}

resource "sonarcloud_quality_gate_project_association" "quality_gate" {
  project_key  = var.project_key
  quality_gate = var.quality_gate_name
}

resource "sonarcloud_project_permissions" "permissions" {
  project      = var.project_key
  group        = var.group_name
  permissions  = var.permissions
}

output "project_url" {
  value = sonarcloud_project.project.url
}