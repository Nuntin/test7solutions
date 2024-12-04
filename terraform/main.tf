resource "google_compute_network" "main" {
  name                    = "${var.project_name}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "public" {
  count         = length(var.availability_zones)
  name          = "${var.project_name}-public-subnet"
  ip_cidr_range = cidrsubnet(var.vpc_cidr, 8, count.index)
  region        = var.region
  network       = google_compute_network.main.id

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "${var.project_name}-public-pods"
    ip_cidr_range = cidrsubnet(var.vpc_cidr, 6, 1)
  }

  secondary_ip_range {
    range_name    = "${var.project_name}-public-services"
    ip_cidr_range = cidrsubnet(var.vpc_cidr, 6, 2)
  }
}

resource "google_compute_subnetwork" "private" {
  count         = length(var.availability_zones)
  name          = "${var.project_name}-private-subnet"
  ip_cidr_range = cidrsubnet(var.vpc_cidr, 8, count.index)
  region        = var.region
  network       = google_compute_network.main.id

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "${var.project_name}-private-pods"
    ip_cidr_range = cidrsubnet(var.vpc_cidr, 6, 3)
  }

  secondary_ip_range {
    range_name    = "${var.project_name}-private-services"
    ip_cidr_range = cidrsubnet(var.vpc_cidr, 6, 4)
  }
}

resource "google_compute_router" "router" {
  name    = "${var.project_name}-router"
  region  = var.region
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.project_name}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}