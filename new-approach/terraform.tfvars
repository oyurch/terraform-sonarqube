sonarcloud_organization = "oyurch"

quality_gates = {
  gate1 = {
    name = "Quality Gate 1"
    conditions = [
      "metric=coverage&operator=GT&error=80",
      "metric=new_coverage&operator=GT&error=80"
    ]
  },
  gate2 = {
    name = "Quality Gate 2"
    conditions = [
      "metric=bugs&operator=LT&error=1",
      "metric=new_bugs&operator=LT&error=1"
    ]
  }
}

projects = {
  project1 = {
    name        = "Project 1"
    key         = "project_1_key"
    quality_gate = "gate1"
  },
  project2 = {
    name        = "Project 2"
    key         = "project_2_key"
    quality_gate = "gate2"
  }
}