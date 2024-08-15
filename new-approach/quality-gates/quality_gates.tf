resource "null_resource" "create_quality_gate" {
  for_each = var.quality_gates

  provisioner "local-exec" {
    command = <<EOT
      curl -X POST \
      -u ${var.sonarcloud_token}: \
      "https://sonarcloud.io/api/qualitygates/create" \
      -d "organization=${var.sonarcloud_organization}&name=${each.value.name}"
    EOT
  }

  provisioner "local-exec" {
    when    = "create"
    command = <<EOT
      for condition in ${join(" ", each.value.conditions)}; do
        curl -X POST \
        -u ${var.sonarcloud_token}: \
        "https://sonarcloud.io/api/qualitygates/create_condition" \
        -d "organization=${var.sonarcloud_organization}&gateName=${each.value.name}&$condition"
      done
    EOT
  }
}