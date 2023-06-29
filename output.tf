output "invetory_data" {
  description = "Data from inventory"
  value       = data.google_cloud_asset_resources_search_all.projects
}