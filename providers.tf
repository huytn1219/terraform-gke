#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PREPARE PROVIDERS
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
provider "google" {
    version = "~> 2.9.0"
    project = var.project 
    region  = var.region 
}

data "google_client_config" "default" {}

provider "kubernetes" {
    load_config_file       = "false"
    host = "https://${module.gke_cluster.endpoint}"

    token = "${data.google_client_config.default.access_token}"

    client_certificate     = module.gke_cluster.client_certificate
    client_key             = module.gke_cluster.client_key
    cluster_ca_certificate = module.gke_cluster.cluster_ca_certificate
}

provider "helm" {
    version        = "~> 1.0.0"
    kubernetes {
        load_config_file = "false"
        host = "https://${module.gke_cluster.endpoint}"

        token = "${data.google_client_config.default.access_token}"

        client_certificate     = module.gke_cluster.client_certificate
        client_key             = module.gke_cluster.client_key
        cluster_ca_certificate = module.gke_cluster.cluster_ca_certificate
    }
  
}
