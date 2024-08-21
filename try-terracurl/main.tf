terraform {
  required_providers {
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "1.0.0"
    }
  }
}

provider "terracurl" {}

# Create quality gates
resource "terracurl_request" "create_quality_gate" {
  for_each = toset(var.quality_gates)

  name           = "CreateQualityGate-${each.key}"
  method         = "POST"
  url            = "https://sonarcloud.io/api/qualitygates/create?organization=${var.sonarcloud_organization}&name=${urlencode(each.key)}"
  response_codes = ["200"]

  headers = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }
}

resource "terracurl_request" "delete_quality_gate" {
  for_each = toset(var.quality_gates)

  name           = "DeleteQualityGate-${each.key}"
  method         = "POST"
  url            = "https://sonarcloud.io/api/qualitygates/list?organization=${var.sonarcloud_organization}"
  response_codes = ["200"]

  headers = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }
  destroy_method = "POST"
  destroy_url = "https://sonarcloud.io/api/qualitygates/destroy?organization=${var.sonarcloud_organization}&id=${lookup(jsondecode(data.terracurl_request.get_quality_gate[each.key].response), "id", "")}"
  destroy_headers = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }
  destroy_response_codes = ["204"]

  depends_on = [terracurl_request.create_quality_gate]
}

data "terracurl_request" "get_quality_gate" {
  for_each = toset(var.quality_gates)

  name           = "GetQualityGate-${each.key}"
  method         = "GET"
  url            = "https://sonarcloud.io/api/qualitygates/show?organization=${var.sonarcloud_organization}&name=${urlencode(each.key)}"
  response_codes = ["200"]

  headers = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }

    depends_on = [terracurl_request.create_quality_gate]
}

# Set up conditions for each quality gate
resource "terracurl_request" "create_condition" {
#
  for_each = {
    for k, condition in var.quality_gate_conditions : "${condition.gate_name}-${condition.metric}" => {
        gate_name = condition.gate_name
        metric    = condition.metric
        operator  = condition.operator
        error     = condition.error
    }
  }
  headers = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }

  name           = "CreateCondition-${each.key}"
  method         = "POST"
  url            = "https://sonarcloud.io/api/qualitygates/create_condition?organization=${var.sonarcloud_organization}&gateId=${lookup(jsondecode(data.terracurl_request.get_quality_gate[each.value.gate_name].response), "id", 9)}&metric=${each.value.metric}&op=${each.value.operator}&error=${each.value.error}"
  response_codes = ["200"]

  depends_on = [terracurl_request.create_quality_gate]
}

# Create each project
resource "terracurl_request" "create_project" {
  for_each = var.projects

  name           = "CreateProject-${each.key}"
  method         = "POST"
  url            = "https://sonarcloud.io/api/projects/create?organization=${var.sonarcloud_organization}&name=${each.value.name}&project=${each.value.project}&newCodeDefinitionType=${each.value.newCodeDefinitionType}&newCodeDefinitionValue=${each.value.newCodeDefinitionValue}"
  response_codes = ["200"]

  headers = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }

  # Destroy the project
  destroy_url    = "https://sonarcloud.io/api/projects/delete?project=${each.value.project}"
  destroy_method = "POST"

  destroy_headers = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }

  destroy_response_codes = [
    204
  ]

  depends_on = [terracurl_request.create_quality_gate]
}

# Assign the appropriate quality gate to each project
resource "terracurl_request" "assign_quality_gate" {
  for_each = var.projects

  name           = "AssignQualityGate-${each.key}"
  method         = "POST"
  url            = "https://sonarcloud.io/api/qualitygates/select?organization=${var.sonarcloud_organization}&projectKey=${each.value.project}&gateId=${lookup(jsondecode(data.terracurl_request.get_quality_gate[each.value.quality_gate_name].response), "id", 9)}"
  response_codes = ["204", "200"]

  headers = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }

  depends_on = [terracurl_request.create_quality_gate, terracurl_request.create_project]
}