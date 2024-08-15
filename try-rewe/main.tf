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

resource "sonarcloud_project_main_branch" "main" {
  project_key = "${var.organization_key}_try_drf"
  name        = "master"
}

resource "sonarcloud_quality_gate" "be-python-standard" {
  name       = "be-python-standard"
  is_default = false
  conditions = [
    // Less than 100% coverage on new code
    {
      metric = "new_coverage"
      error  = 100
      op     = "LT"
    },
    {
      metric = "new_line_coverage"
      error  = 100
      op     = "LT"
    },
    {
      metric = "new_conditions_to_cover"
      error  = 10
      op     = "LT"
    },
    {
      metric = "new_duplicated_lines_density"
      error  = 100
      op     = "LT"
    },
    // More than 0.1% duplicated lines on new code
    {
      metric = "new_duplicated_lines_density"
      error  = 0.1
      op     = "GT"
    },
    // More than 0 security rating on new code
    {
      metric = "new_security_rating"
      error  = 0
      op     = "GT"
    },
    // More than 0 maintainability rating on new code
    {
      metric = "new_maintainability_rating"
      error  = 0
      op     = "GT"
    },
    {
      metric = "new_code_smells"
      error  = 0
      op     = "GT"
    },
    {
      metric = "new_critical_violations"
      error  = 0
      op     = "GT"
    },
    {
      metric = "new_lines_to_cover"
      error  = 700
      op     = "GT"
    },
  ]
}
