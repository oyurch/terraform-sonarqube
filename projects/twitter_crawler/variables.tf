variable "sonarcloud_api_token" {
  type        = string
  description = "The API token for SonarCloud"
}

variable "organization_key" {
  type        = string
  description = "The SonarCloud organization key"
}

variable "project_key" {
  type        = string
  description = "The SonarCloud project key"
  default = "twitter_crawler"
}

variable "project_name" {
  type        = string
  description = "The SonarCloud project name"
  default = "Twitter Crawler"
}

variable "quality_gate_id" {
  type        = string
  description = "The SonarCloud quality gate ID"
}

variable "group_name" {
  type        = string
  description = "The name of the group to add permissions to"
}

variable "permission" {
  type        = string
  description = "The permission to add to the group"
}
variable "sources" {
  type = string
  description = "The source code paths to analyze"
  default = "."
}

variable "tests" {
  type = string
  description = "The test paths to analyze"
  default = "tests"
}

variable "coverage_report_paths" {
  type = string
  description = "The paths to the coverage reports"
  default = "./coverage.xml"
}