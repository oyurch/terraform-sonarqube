variable "sonarcloud_token" {
  type        = string
  description = "The SonarCloud API token"
}

variable "sonarcloud_organization" {
  type        = string
  description = "The SonarCloud organization key"
}

variable "quality_gates" {
  type = map(object({
    name = string
    conditions = list(map(string))
  }))
  description = "A map of quality gates to create"
}

variable "projects" {
  type = map(object({
    name        = string
    key         = string
    quality_gate = string
  }))
  description = "A map of projects to create"
}