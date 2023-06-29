variable "bucket_name" {
  description = "Name of the Cloud Storage bucket"
  default     = "asset_bucket_2"
}

variable "asset_types" {
  type        = list(string)
  description = "List of asset types to export"
  default     = [
    "google.compute.Instance",
    "google.cloud.resourcemanager.Project"
  ]
}