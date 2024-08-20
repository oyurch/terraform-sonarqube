output "quality_gate_responses" {
  value = { for k, v in data.terracurl_request.get_quality_gate : k => v.response }
}

output "create_project_responses" {
  value = { for k, v in terracurl_request.create_project : k => v.response }
}
