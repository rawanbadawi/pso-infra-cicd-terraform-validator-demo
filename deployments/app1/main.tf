
# cloudrun

# Used to retrieve project_number later
data "google_project" "project" {
  provider = google-beta
  project_id = var.project_id
}

# Enable Cloud Run API
resource "google_project_service" "run" {
  provider = google-beta
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_cloud_run_service" "default" {
  name     = var.app_name
  location = var.location

  template {
    spec {
      containers {
        image = var.image
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
  depends_on = [google_project_service.run]
}