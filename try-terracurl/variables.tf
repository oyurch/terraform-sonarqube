variable "sonarcloud_api_token" {
    description = "The SonarCloud API token"
    type        = string
    sensitive   = true
}

variable "default_quality_gate_id" {
    // it's created automaticaly by SonarCloud after we create organization
    description = "The default quality gate ID"
    type        = string
    default     = "9"
}

variable "projects_api_url" {
    description = "The SonarCloud projects API URL"
    type        = string
    default     = "https://sonarcloud.io/api/projects"
}

variable "quality_gates_api_url" {
    description = "The SonarCloud quality gates API URL"
    type        = string
    default     = "https://sonarcloud.io/api/qualitygates"
}

variable "sonarcloud_organization" {
  description = "The SonarCloud organization key"
  type        = string
}


variable "quality_gates" {
  description = "Map of conditions for each quality gate"
  type = map(list(object({
    metric   = string
    operator = string
    error    = string
  })))
}

variable "projects" {
  description = "Map of projects with their assigned quality gates"
  type = map(object({
    name             = string
    project          = string
    quality_gate_name = string
    new_code_definition = object({
      type  = string
      value = string
    })
  }))
}