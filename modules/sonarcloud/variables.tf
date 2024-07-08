variable "sonarcloud_api_token" {
  type = string
}

variable "organization_key" {
  type = string
}

variable "project_key" {
  type = string
}

variable "project_name" {
  type = string
}

variable "quality_gate_name" {
  type = string
  default = "Sonar way"
}

variable "group_name" {
  type = string
}

variable "permissions" {
  type = list(string)
}