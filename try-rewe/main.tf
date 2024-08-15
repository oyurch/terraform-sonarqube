terraform {
  required_providers {
    sonarcloud = {
      source = "rewe-digital/sonarcloud"
      version = "0.5.2"
    }
  }
}

provider "sonarcloud" {
  token = var.sonarcloud_api_token
  organization = var.organization_key
}

resource "sonarcloud_project" "try_drf" {
  key  = "${var.organization_key}_try_drf"
  name = "Try DRF"
  visibility = "public"
}
