resource "google_cloud_run_service" "vidamajuna-api" {
  name     = "vidamajuna-api"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/${var.service}:${var.image_tag}"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {

  depends_on = [
    google_cloud_run_service.vidamajuna-api,
  ]

  location    = var.region
  project     = var.project_id
  service     = var.service

  policy_data = data.google_iam_policy.noauth.policy_data
}