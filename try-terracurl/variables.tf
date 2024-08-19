variable "sonarcloud_token" {
  type = string
}

variable "sonarcloud_organization" {
  type = string
}

variable "quality_gates" {
  type = map(object({
    name       = string
    conditions = list(object({
      metric   = string
      operator = string
      error    = string
    }))
  }))
}