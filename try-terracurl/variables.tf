variable "sonarcloud_api_token" {}
variable "sonarcloud_organization" {
  description = "The SonarCloud organization key"
  type        = string
}

variable "quality_gates" {
  description = "List of quality gates to create"
  type = list(string)
}

variable "quality_gate_conditions" {
  description = "Map of conditions for each quality gate"
  type = list(object({
    gate_name = string
    metric   = string
    operator = string
    error    = string
  }))
}

variable "projects" {
  description = "Map of projects with their assigned quality gates"
  type = map(object({
    name             = string
    project          = string
    quality_gate_name = string
    newCodeDefinitionType = string
    newCodeDefinitionValue = number
  }))
}