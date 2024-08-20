sonarcloud_organization = "oyurch"

quality_gates = ["Quality Gate 1", "Quality Gate 2"]

quality_gate_conditions = [
  # Quality Gate 2

  {
    gate_name = "Quality Gate 1"
    metric   = "coverage"
    operator = "LT"
    error    = "80"
  },
  {
    gate_name = "Quality Gate 1"
    metric   = "new_coverage"
    operator = "LT"
    error    = "80"
  },
  {
    gate_name = "Quality Gate 1"
    metric   = "new_maintainability_rating"
    operator = "GT"
    error    = "1"
  },
  {
    gate_name = "Quality Gate 1"
    metric   = "new_security_hotspots_reviewed"
    operator = "LT"
    error    = "100"
  },
  {
    gate_name = "Quality Gate 1"
    metric   = "new_duplicated_lines_density"
    operator = "GT"
    error    = "3"
  },
  {
    gate_name = "Quality Gate 1"
    metric   = "new_security_rating"
    operator = "GT"
    error    = "1"
  },
  {
    gate_name = "Quality Gate 1"
    metric   = "new_reliability_rating"
    operator = "GT"
    error    = "1"
  },

  # Quality Gate 2
  {
    gate_name = "Quality Gate 2"
    metric   = "bugs"
    operator = "GT"
    error    = "1"
  },
  {
    gate_name = "Quality Gate 2"
    metric   = "new_bugs"
    operator = "GT"
    error    = "1"
  }
]

projects = {
  project1 = {
    name              = "Project1"
    project           = "project_1_key"
    quality_gate_name = "Quality Gate 1"
    newCodeDefinitionType = "days"
    newCodeDefinitionValue = 30
  },
  project2 = {
    name             = "Project2"
    project           = "project_2_key"
    quality_gate_name = "Quality Gate 2"
    newCodeDefinitionType = "days"
    newCodeDefinitionValue = 30
  }
}