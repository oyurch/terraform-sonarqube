terraform {
  required_providers {
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "1.0.0"
    }
  }
}

provider "terracurl" {}

resource "terracurl_request" "create_quality_gate" {
  for_each = var.quality_gates

  url = "https://sonarcloud.io/api/qualitygates/create"
  method = "POST"
  headers = {
    Authorization = "Basic ${base64encode(var.sonarcloud_api_token)}"
  }
  body = jsonencode({
    organization = var.sonarcloud_organization
    name         = each.value.name
  })

  response_code = 200
  name          = ""
  response_codes = []
}

// trigger build

resource "terracurl_request" "get_quality_gate_id" {
  for_each = var.quality_gates

  url = "https://sonarcloud.io/api/qualitygates/show"
  method = "POST"
  headers = {
    Authorization = "Basic ${base64encode(var.sonarcloud_api_token)}"
  }
  body = jsonencode({
    organization = var.sonarcloud_organization
  })

  response_code = 200

  # Use jq to extract the gate_id from the response
  response_extractor = {
    gate_id = ".qualitygates[] | select(.name==\"${each.value.name}\") | .id"
  }

  depends_on = [terracurl_request.create_quality_gate]
  name = ""
  response_codes = []
}

resource "terracurl_request" "add_quality_gate_conditions" {
  for_each = var.quality_gates

#   count_ = length(each.value.conditions)

  url = "https://sonarcloud.io/api/qualitygates/create_condition"
  method = "POST"
  headers = {
    Authorization = "Basic ${base64encode(var.sonarcloud_api_token)}"
  }
  body = jsonencode({
    gateId   = jsonencode(terracurl_request.get_quality_gate_id[each.key].request_body).gate_id
    metric   = each.value.conditions[count.index].metric
    op       = each.value.conditions[count.index].operator
    error    = each.value.conditions[count.index].error
  })

  response_code = 200

  depends_on = [terracurl_request.get_quality_gate_id]
  name = ""
  response_codes = []
}