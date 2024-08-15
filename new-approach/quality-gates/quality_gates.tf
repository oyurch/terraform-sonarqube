resource "null_resource" "manage_quality_gate" {
  for_each = var.quality_gates

  triggers = {
    sonarcloud_token       = var.sonarcloud_api_token
    sonarcloud_organization = var.sonarcloud_organization
    gate_name              = each.value.name
  }

  provisioner "local-exec" {
    when = create
    command = <<EOT
      gate_id=$(curl -s -u ${self.triggers.sonarcloud_token}: "https://sonarcloud.io/api/qualitygates/create" -d "organization=${self.triggers.sonarcloud_organization}&name=${self.triggers.gate_name}" | jq -r '.id')

      if [ -z "$gate_id" ]; then
        echo "Error: Quality gate creation failed"
        exit 1
      fi

      $(for condition in ${jsonencode(each.value.conditions)}; do
          metric=$(echo $condition | jq -r '.metric')
          operator=$(echo $condition | jq -r '.operator')
          error=$(echo $condition | jq -r '.error')

          echo curl -X POST \
            -u ${self.triggers.sonarcloud_token}: \
            "https://sonarcloud.io/api/qualitygates/create_condition" \
            -d "'gateId=$gate_id&metric=$metric&op=$operator&error=$error'"
        done)
    EOT
  }

  provisioner "local-exec" {
    when = destroy
    command = <<EOT
      gate_id=$(curl -s -u ${self.triggers.sonarcloud_token}: "https://sonarcloud.io/api/qualitygates/show" -d "organization=${self.triggers.sonarcloud_organization}" | jq -r '.qualitygates[] | select(.name=="${self.triggers.gate_name}") | .id')

      if [ -n "$gate_id" ]; then
        curl -X POST \
        -u ${self.triggers.sonarcloud_token}: \
        "https://sonarcloud.io/api/qualitygates/destroy" \
        -d "id=$gate_id&organization=${self.triggers.sonarcloud_organization}"
      fi
    EOT
  }
}