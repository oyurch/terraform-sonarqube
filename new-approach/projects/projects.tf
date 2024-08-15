resource "null_resource" "create_project" {
  for_each = var.projects

  provisioner "local-exec" {
    command = <<EOT
      curl -X POST \
      -u ${var.sonarcloud_api_token}: \
      "https://sonarcloud.io/api/projects/create" \
      -d "organization=${var.sonarcloud_organization}&project=${each.value.key}&name=${each.value.name}"
    EOT
  }
}

resource "null_resource" "assign_quality_gate" {
  for_each = var.projects

  provisioner "local-exec" {
    command = <<EOT
      curl -X POST \
      -u ${var.sonarcloud_api_token}: \
      "https://sonarcloud.io/api/qualitygates/select" \
      -d "organization=${var.sonarcloud_organization}&projectKey=${each.value.key}&gateName=${var.quality_gates[each.value.quality_gate].name}"
    EOT
  }
  depends_on = [null_resource.create_project]
}