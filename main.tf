# Define the provider and required variables
provider "google" {
  project = "rosy-crawler-389806"
  region  = "europe-west1"
}

# Enable the Asset Inventory API
resource "google_project_service" "asset_inventory" {
  service = "cloudasset.googleapis.com"
  project = "rosy-crawler-389806"
}

# Create a Cloud Storage bucket
resource "google_storage_bucket" "my_bucket" {
  name     = var.bucket_name
  location = "europe-west1"
}

# Configure the Asset Inventory export
resource "google_cloud_asset_project_feed" "my_project_feed" {
  project = "rosy-crawler-389806"
  feed_id = "my-project-feed"
  content_type     = "RESOURCE"

  asset_types = [
    "compute.googleapis.com/Subnetwork",
    "compute.googleapis.com/Network",
  ]

   feed_output_config {
    pubsub_destination {
      topic = google_pubsub_topic.feed_output.id
    }
    }

    condition {
    expression = <<-EOT
    !temporal_asset.deleted &&
    temporal_asset.prior_asset_state == google.cloud.asset.v1.TemporalAsset.PriorAssetState.DOES_NOT_EXIST
    EOT
    title = "created"
    description = "Send notifications on creation events"
  }

}

# The topic where the resource change notifications will be sent.
resource "google_pubsub_topic" "feed_output" {
  project  = "rosy-crawler-389806"
  name     = "my-project-feed"
}

data google_cloud_asset_resources_search_all projects {
  provider = google-beta
  scope = "organizations/494812795773"
  asset_types = [
    "cloudresourcemanager.googleapis.com/Project"
  ]
}


# Configure the IAM policy for the Cloud Storage bucket
//resource "google_storage_bucket_iam_binding" "my_bucket_iam_binding" {
//  bucket = google_storage_bucket.my_bucket.name
//  role   = "roles/storage.objectCreator"
//  members = [
//    "serviceAccount:${google_cloud_asset_project_feed.my_project_feed.service_account_email}"
//  ]
//}