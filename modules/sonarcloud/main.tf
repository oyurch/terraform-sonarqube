terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 2.0"
    }
  }
}

provider "http" {}

resource "null_resource" "create_project" {
  provisioner "local-exec" {
    command = <<EOT
      curl -u ${var.sonarcloud_api_token}: \
           -X POST "https://sonarcloud.io/api/projects/create" \
           -d "organization=${var.organization_key}" \
           -d "name=${var.project_name}" \
           -d "project=${var.project_key}"
    EOT
  }
}

resource "null_resource" "update_project" {
  provisioner "local-exec" {
    command = <<EOT
      curl -u ${var.sonarcloud_api_token}: \
           -X POST "https://sonarcloud.io/api/projects/update" \
           -d "organization=${var.organization_key}" \
           -d "name=${var.project_name}" \
           -d "project=${var.project_key}"
    EOT
  }
  depends_on = [null_resource.create_project]
}

resource "null_resource" "assign_quality_gate" {
  provisioner "local-exec" {
    command = <<EOT
      curl -u ${var.sonarcloud_api_token}: \
           -X POST "https://sonarcloud.io/api/qualitygates/select" \
           -d "projectKey=${var.project_key}" \
           -d "gateId=${var.quality_gate_id}"
    EOT
  }
  depends_on = [null_resource.update_project]
}

resource "null_resource" "set_permissions" {
  provisioner "local-exec" {
    command = <<EOT
      curl -u ${var.sonarcloud_api_token}: \
           -X POST "https://sonarcloud.io/api/permissions/add_group" \
           -d "projectKey=${var.project_key}" \
           -d "groupName=${var.group_name}" \
           -d "permission=${var.permission}"
    EOT
  }
  depends_on = [null_resource.update_project]
}

output "project_url" {
  value = "https://sonarcloud.io/dashboard?id=${var.project_key}"
}