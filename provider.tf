provider "google-beta" {
  project = var.project_id
}

provider "helm" {
  kubernetes {
    load_config_file       = false
    host                   = "https://${google_container_cluster.gke_cluster.endpoint}"
    token                  = data.google_client_config.current.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate)
  }
}

terraform {
  backend "gcs" {
    prefix = "terraform/state"
  }
}