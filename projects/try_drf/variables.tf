variable "sonarcloud_api_token" {
  type        = string
  description = "The API token for SonarCloud"
}

variable "organization_key" {
  type        = string
  description = "The SonarCloud organization key"
  default     = "oyurch"
}

variable "project_key" {
  type        = string
  description = "The SonarCloud project key"
  default     = "oyurch_try_drf"
}

variable "project_name" {
  type        = string
  description = "The SonarCloud project name"
  default     = "Try DRF"
}

variable "quality_gate_id" {
  type        = string
  description = "The SonarCloud quality gate ID"
  default     = "9"
}

variable "group_name" {
  type        = string
  description = "The name of the group to add permissions to"
  default     = "members"
}

variable "permissions" {
  type        = list(string)
  description = "The permission to add to the group"
  default     = ["admin", "codeviewer"]
}