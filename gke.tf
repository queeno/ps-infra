data "google_client_config" "current" {}

resource "google_container_cluster" "gke_cluster" {
  provider = google-beta
  name     = "paymentsense"
  location = "${var.region}-a"
  network  = google_compute_network.vpc_network.name

  initial_node_count       = "1"
  remove_default_node_pool = true

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }

  subnetwork = google_compute_subnetwork.vpc_subnetwork.self_link

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "10.172.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "open to everywhere"
    }
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }
  }
}

resource "google_container_node_pool" "preemptible_node_pool" {
  name       = "preemptible"
  cluster    = google_container_cluster.gke_cluster.name
  node_count = "1"

  autoscaling {
    max_node_count = 2
    min_node_count = 0
  }

  location = "${var.region}-a"

  node_config {
    machine_type = "n1-standard-2"
    disk_size_gb = "20"
    preemptible  = "true"
  }
}