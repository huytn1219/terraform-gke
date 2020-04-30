# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "project" {
    description = "The project ID where all resources will be launched."
    type        = string
    default     = "shipwire-eng-core-dev"
}

variable "location" {
    description = "The location (region or zone) of the GKE cluster."
    type        = string
    default     = "us-west1"
}

variable "region" {
    description = "The region for the network. If the cluster is regional, this must be the same region. Otherwise, it should be the region of the zone."
    type        = string
    default     = "us-west1"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
    description = "Name of the Kubernetes cluster."
    type        = string
    default     = "test-alpha-cluster"
}

variable "cluster_service_account_name" {
    description = "The name of the custom service account used for the GKE cluster. This parameter is limited to a maximum of 28 characters."
    type        = string
    default     = "test-alpha-cluster"
}

variable "cluster_service_account_description" {
    description = "A description of the custom account used for the GKE cluster."
    type        = string
    default     = "Example GKE Cluster Service Account managed by Terraform"
}

variable "vpc_cidr_block" {
    description = "The IP address range of the VPC in CIDR notation. A prefix of /16 is recommnded. Do not use a prefix higher than /27."
    type        = string
    default     = "10.8.0.0/16"
}

variable "vpc_secondary_cidr_block" {
    description = "The IP address range of the VPC's secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
    type        = string
    default     = "10.9.0.0/16"
}



