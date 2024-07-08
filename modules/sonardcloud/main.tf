provider "null" {}

provider "http" {
  version = "~> 2.0"
}

resource "null_resource" "create_project" {
  provisioner "local-exec" {
    command = <<EOT
      curl -u ${var.sonarcloud_api_token}: \
           -X POST "https://sonarcloud.io/api/projects/create?organization=${var.organization_key}&name=${var.project_name}&project=${var.project_key}"
    EOT
  }
}

resource "null_resource" "assign_quality_gate" {
  provisioner "local-exec" {
    command = <<EOT
      curl -u ${var.sonarcloud_api_token}: \
           -X POST "https://sonarcloud.io/api/qualitygates/select?projectKey=${var.project_key}&gateId=${var.quality_gate_id}"
    EOT
  }
  depends_on = [null_resource.create_project]
}

resource "null_resource" "set_permissions" {
  provisioner "local-exec" {
    command = <<EOT
      curl -u ${var.sonarcloud_api_token}: \
           -X POST "https://sonarcloud.io/api/permissions/add_group?projectKey=${var.project_key}&groupName=${var.group_name}&permission=${var.permission}"
    EOT
  }
  depends_on = [null_resource.create_project]
}