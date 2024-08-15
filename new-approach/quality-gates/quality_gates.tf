resource "null_resource" "create_quality_gate" {
  for_each = var.quality_gates

  provisioner "local-exec" {
    command = <<EOT
      curl -X POST \
      -u ${var.sonarcloud_api_token}: \
      "https://sonarcloud.io/api/qualitygates/create" \
      -d "organization=${var.sonarcloud_organization}&name=${each.value.name}"
    EOT
  }

  provisioner "local-exec" {
    when = create
    command = <<EOT
      gate_id=$(curl -s -u ${var.sonarcloud_api_token}: "https://sonarcloud.io/api/qualitygates/show" -d "organization=${var.sonarcloud_organization}" | jq -r '.qualitygates[] | select(.name=="${each.value.name}") | .id')

      for condition in ${jsonencode(each.value.conditions)}; do
        metric=$(echo $condition | jq -r '.metric')
        operator=$(echo $condition | jq -r '.operator')
        error=$(echo $condition | jq -r '.error')

        curl -X POST \
        -u ${var.sonarcloud_api_token}: \
        "https://sonarcloud.io/api/qualitygates/create_condition" \
        -d "organization=${var.sonarcloud_organization}&gateId=$gate_id&metric=$metric&op=$operator&error=$error"
      done
    EOT
  }
}

resource "null_resource" "quality_gate_data" {
  for_each = var.quality_gates

  triggers = {
    sonarcloud_token       = var.sonarcloud_api_token
    sonarcloud_organization = var.sonarcloud_organization
    gate_name              = each.value.name
  }
}

resource "null_resource" "delete_quality_gate" {
  for_each = var.quality_gates

  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
      gate_id=$(curl -s -u ${self.triggers.sonarcloud_token}: "https://sonarcloud.io/api/qualitygates/show" -d "organization=${self.triggers.sonarcloud_organization}" | jq -r '.qualitygates[] | select(.name=="${self.triggers.gate_name}") | .id')

      if [ -n "$gate_id" ]; then
        curl -X POST \
        -u ${self.triggers.sonarcloud_token}: \
        "https://sonarcloud.io/api/qualitygates/delete" \
        -d "id=$gate_id"
      fi
    EOT
  }
  depends_on = [null_resource.quality_gate_data]
}