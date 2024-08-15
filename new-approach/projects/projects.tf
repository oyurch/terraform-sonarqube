resource "null_resource" "manage_project" {
  for_each = var.projects

  triggers = {
    sonarcloud_token       = var.sonarcloud_api_token
    sonarcloud_organization = var.sonarcloud_organization
    project_key            = each.value.key
    project_name           = each.value.name
    quality_gate_name      = each.value.quality_gate
  }

  provisioner "local-exec" {
    when = create
    command = <<EOT
      curl -X POST \
      -u ${self.triggers.sonarcloud_token}: \
      "https://sonarcloud.io/api/projects/create" \
      -d "organization=${self.triggers.sonarcloud_organization}&project=${self.triggers.project_key}&name=${self.triggers.project_name}"

      gate_id=$(curl -s -u ${self.triggers.sonarcloud_token}: "https://sonarcloud.io/api/qualitygates/show" -d "organization=${self.triggers.sonarcloud_organization}" | jq -r '.qualitygates[] | select(.name=="${self.triggers.quality_gate_name}") | .id')

      if [ -z "$gate_id" ]; then
        echo "Error: Quality gate ID not found"
        exit 1
      fi

      curl -X POST \
      -u ${self.triggers.sonarcloud_token}: \
      "https://sonarcloud.io/api/qualitygates/select" \
      -d "organization=${self.triggers.sonarcloud_organization}&projectKey=${self.triggers.project_key}&gateId=$gate_id"
    EOT
  }

  provisioner "local-exec" {
    when = destroy
    command = <<EOT
      curl -X POST \
      -u ${self.triggers.sonarcloud_token}: \
      "https://sonarcloud.io/api/projects/delete" \
      -d "organization=${self.triggers.sonarcloud_organization}&project=${self.triggers.project_key}"
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
  depends_on = [null_resource.manage_project]
}