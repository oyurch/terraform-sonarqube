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
    when    = create
    command = <<EOT
      for condition in ${jsonencode(each.value.conditions)}; do
        metric=$(echo $condition | jq -r '.metric')
        operator=$(echo $condition | jq -r '.operator')
        error=$(echo $condition | jq -r '.error')

        curl -X POST \
        -u ${var.sonarcloud_api_token}: \
        "https://sonarcloud.io/api/qualitygates/create_condition" \
        -d "organization=${var.sonarcloud_organization}&gateName=${each.value.name}&metric=$metric&operator=$operator&error=$error"
      done
    EOT
  }
}