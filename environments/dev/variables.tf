variable "sonarcloud_api_token" {
  type        = string
  description = "The API token for SonarCloud"
}

variable "organization_key" {
  type        = string
  description = "The SonarCloud organization key"
  default     = "oyurch"
}

variable "quality_gate_name" {
  type        = string
  description = "The SonarCloud quality gate ID"
  default     = "Sonar way"
}

variable "group_name" {
  type        = string
  description = "The name of the group to add permissions to"
  default     = "members"
}

variable "permissions" {
  type        = list(string)
  description = "The permission to add to the group"
  default     = ["admin"]
}