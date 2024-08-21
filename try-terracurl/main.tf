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
  for_each = tomap(var.quality_gates)

  name           = "CreateQualityGate-${each.key}"
  method         = "POST"
  url            = "${var.quality_gates_api_url}/create?organization=${var.sonarcloud_organization}&name=${urlencode(each.key)}"
  response_codes = ["200"]

  headers        = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }
}

resource "terracurl_request" "delete_quality_gate" {
  for_each = tomap(var.quality_gates)

  # we need this to mock resource creation part of the lifecycle for the destroy part
  name           = "DeleteQualityGate-${each.key}"
  method         = "POST"
  url            = "${var.quality_gates_api_url}/list?organization=${var.sonarcloud_organization}"
  response_codes = ["200"]

  headers = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }

  destroy_method = "POST"
  destroy_url    = "${var.quality_gates_api_url}/destroy?organization=${var.sonarcloud_organization}&id=${lookup(jsondecode(data.terracurl_request.get_quality_gate[each.key].response), "id", "")}"
  destroy_headers = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }
  destroy_response_codes = ["204"]

  depends_on    = [terracurl_request.create_quality_gate]
}

data "terracurl_request" "get_quality_gate" {
  for_each       = tomap(var.quality_gates)

  name           = "GetQualityGate-${each.key}"
  method         = "GET"
  url            = "${var.quality_gates_api_url}/show?organization=${var.sonarcloud_organization}&name=${urlencode(each.key)}"
  response_codes = ["200"]

  headers        = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }

  depends_on     = [terracurl_request.create_quality_gate]
}

locals {
  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  conditions_with_gate = flatten([
    for gate_name, conditions in var.quality_gates : [
      for k, condition in conditions : {
        gate_name = gate_name
        condition = condition
      }
    ]
  ])
}

# Set up conditions for each quality gate
resource "terracurl_request" "create_condition" {
#
  for_each = {
    for k, row in local.conditions_with_gate : "${row.gate_name}-${row.condition.metric}" => {
        gate_name = row.gate_name
        metric    = row.condition.metric
        operator  = row.condition.operator
        error     = row.condition.error
    }
  }
  headers = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }

  name           = "CreateCondition-${each.key}"
  method         = "POST"
  url            = "${var.quality_gates_api_url}/create_condition?organization=${var.sonarcloud_organization}&gateId=${lookup(jsondecode(data.terracurl_request.get_quality_gate[each.value.gate_name].response), "id", var.default_quality_gate_id)}&metric=${each.value.metric}&op=${each.value.operator}&error=${each.value.error}"
  response_codes = ["200"]

  depends_on = [terracurl_request.create_quality_gate]
}

# Create each project
resource "terracurl_request" "create_project" {
  for_each = var.projects

  name           = "CreateProject-${each.key}"
  method         = "POST"
  url            = "${var.projects_api_url}/create?organization=${var.sonarcloud_organization}&name=${each.value.name}&project=${each.value.project}&newCodeDefinitionType=${each.value.new_code_definition.type}&newCodeDefinitionValue=${each.value.new_code_definition.value}"
  response_codes = ["200"]

  headers        = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }

  # Destroy the project
  destroy_url            = "${var.projects_api_url}/delete?project=${each.value.project}"
  destroy_method         = "POST"

  destroy_headers        = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }

  destroy_response_codes = [
    204
  ]

  depends_on    = [terracurl_request.create_quality_gate]
}

# Assign the appropriate quality gate to each project
resource "terracurl_request" "assign_quality_gate" {
  for_each = var.projects

  name           = "AssignQualityGate-${each.key}"
  method         = "POST"
  url            = "${var.quality_gates_api_url}/select?organization=${var.sonarcloud_organization}&projectKey=${each.value.project}&gateId=${lookup(jsondecode(data.terracurl_request.get_quality_gate[each.value.quality_gate_name].response), "id", var.default_quality_gate_id)}"
  response_codes = ["204", "200"]

  headers        = {
    Authorization = "Basic ${base64encode("${var.sonarcloud_api_token}:")}"
  }

  depends_on    = [terracurl_request.create_quality_gate, terracurl_request.create_project]
}