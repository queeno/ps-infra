resource "google_compute_network" "vpc_network" {
  name                    = "ps-infra"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name                     = "ps-infra"
  region                   = var.region
  private_ip_google_access = true
  ip_cidr_range            = "10.156.0.0/20"
  network                  = google_compute_network.vpc_network.self_link

  secondary_ip_range {
    ip_cidr_range = "10.156.16.0/20"
    range_name    = "gke-pods"
  }

  secondary_ip_range {
    ip_cidr_range = "10.156.32.0/27"
    range_name    = "gke-services"
  }
}

resource "google_compute_router" "vpc_router" {
  name    = "ps-infra"
  region  = google_compute_subnetwork.vpc_subnetwork.region
  network = google_compute_network.vpc_network.self_link
}

resource "google_compute_router_nat" "simple_nat" {
  name                               = "ps-infra-nat"
  router                             = google_compute_router.vpc_router.name
  region                             = google_compute_subnetwork.vpc_subnetwork.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}