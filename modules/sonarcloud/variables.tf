variable "sonarcloud_api_token" {
  description = "The API token for SonarCloud"
  type        = string
}

variable "organization_key" {
  description = "The SonarCloud organization key"
  type        = string
}

variable "project_key" {
  description = "The SonarCloud project key"
  type        = string
}

variable "project_name" {
  description = "The SonarCloud project name"
  type        = string
}

variable "quality_gate_id" {
  description = "The SonarCloud quality gate ID"
  type        = string
}

variable "group_name" {
  description = "The name of the group to add permissions to"
  type        = string
}

variable "permission" {
  description = "The permission to add to the group"
  type        = string
}