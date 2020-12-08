resource "google_compute_network" "vpc_network" {
  name = "ps-infra"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name   = "ps-infra"
  region = var.region
  private_ip_google_access = true
  ip_cidr_range = "10.1.0.0/16"
  network = google_compute_network.vpc_network.self_link
}