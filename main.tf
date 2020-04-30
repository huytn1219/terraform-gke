#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY  A GKE PUBLIC CLUSTER IN GOOGLE CLOUD PLATFORM 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
terraform {
    required_version = ">= 0.12.20"
    backend "gcs" {
        bucket = "shipwire-terraform-state-files"
        prefix = "dev"
    }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A PUBLIC GKE CLUSTER 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module "gke_cluster" {
    source = ""
    name = var.cluster_name

    project = var.project
    location = var.location

    # We're deploying the cluster in the 'public' subnet to allow outbound internet traffic.
    network                      = module.vpc_network.network
    subnetwork                   = module.vpc_network.public_subnetwork
    cluster_secondary_range_name = module.vpc_network.public_subnetwork_secondary_range_name
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A NODE POOL 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "google_container_node_pool" "node_pool" {
    provider = google

    name     = "main-pool"
    project  = var.project
    location = var.location
    cluster  = module.gke_cluster.name

    initial_node_count = "1"

    autoscaling {
        min_node_count = "1"
        max_node_count = "1"
    }

    management {
        auto_repair  = "true"
        auto_upgrade = "true"
    }

    node_config {
        image_type   = "COS" # We're using Container-Optimized OS image because it sounds fancy.;)
        machine_type = "n1-standard-1"

        labels = {
            all-pools-example = "true"
        }

        # Add a tag to the instance.
        tags = [
            module.vpc_network.public,
            "public-pool-example",
        ]

        disk_size_gb = "30"
        disk_type    = "pd-standard"
        preemptible  = false

        service_account = module.gke_service_account.email

        oauth_scopes = [
            "https://www.googleapis.com/auth/cloud-platform",
        ]
    }

    lifecycle {
        ignore_changes = [initial_node_count]
    }

    timeouts {
        create = "30m"
        update = "30m"
        delete = "30m"
    }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# GKE Service Account Module 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module "gke_service_account" {
    source = ""
    
    name        = var.cluster_service_account_name
    project     = var.project
    description = var.cluster_service_account_description
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Random String for VPC Network Module
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "random_string" "suffix" {
    length  = 4
    special = false
    upper   = false
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# VPC Network Module 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module "vpc_network" {
    source = ""

    name_prefix = "${var.cluster_name}-network-${random_string.suffix.result}"
    project     = var.project
    region      = var.region

    cidr_block            = var.vpc_cidr_block
    secondary_cidr_block  = var.vpc_secondary_cidr_block
}













