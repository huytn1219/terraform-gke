# GKE Public Cluster

This repo supports creating:

*  A Public GKE Cluster.

With this terraform repo, you can create either a regional or zonal cluster. Generally speaking, we recommend a regional cluster over a zonal cluster.

This repo follows best-practices and runs nodes using a custom service account to follow the principle of least privilege. However you will need to ensure that the Identiry and Access Management (IAM) API has been enabled for the given project. This can be enabled in the [Google API Console](https://console.developers.google.com/apis/api/iam.googleapis.com/overview).


## Modules used:
 | Name | Description | URL |
 | ---- | ----------- | --- |
 | sw-gke-service-account| Create GCP service account for use with a GKE cluster. |  |
 | sw-gke-cluster | Create a public GKE cluster with 1 node. | |
 | sw-gcp-network| Create a Virtual Private Cloud (VPC) on Google Cloud Platform (GCP) to host your cluster in. |  |
 |sw-gcp-network-firewall| Used to configure a standard set of firewall rules for your network. | |



## Dependencies

* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) v0.12.0 or later.

## Usage 

1. Run `terraform init` to initialize a Terraform working directory.
2. Run `terraform plan -out tfplan.tf` to show an execution plan and also store the plan to tfplan.tf file for later use.
3. If the plan looks good, run `terraform apply tfplan.tf` to build or change infrastructure based on the execution plan file generated above. Note: Make sure to fill the required variable values when prompted.
4. To destroy what you have applied, run `terraform destroy`.

## Input

| Name | Description | Type | Default | Required | Example |
| ---- | ----------- | ---- | ------- | -------- | ------- |
| project| The project ID where all resources will be launched.| string| No| Yes| |
| location| The location (region or zone) of the GKE cluster.| string| No| Yes| us-central1|
|region| The region for the network. If the cluster is regional, this ust be the same region. Otherwise, it should be the region of the zone.| string| No | Yes| us-central1-f|
| cluster_name| Name of the Kubernetes cluster.| string| example-cluster| No| mycluster|
| cluster_service_account_name| The name of the custom service account used for GKE cluster. This parameter is limited to a maximm of 28 characters.| string| example-cluster| No | N/A|
|cluster_service_account_description| A description of the custom account used for the GKE cluster.|string|Example GKE Cluster Service Account managed by Terraform|No|N/A|
|vpc_cidr_block| The IP address range of the VPC in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27.|string|10.6.0.0/16|No|N/A|
|vpc_secondary_cidr_block|The IP address range of the VPC's secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27.|string|10.7.0.0/16|No|N/A|

## Output

| Name| Description|
| ----| -----------|
| cluster_endpoint | The IP address of the cluster master.|
| client_certificaite| Public certificate used by clients to authenticate to the cluster endpoint.|
|client_key| Private key used by the clients to authenticate to the cluster endpoints.|
|cluster_ca_certificate|The public certificate that is the root of trust for the cluster.|

## License & References:

Please see [LICENSE](https://github.com/gruntwork-io/terraform-google-gke/blob/master/LICENSE) for how the code in this repo is licensed.
Please also see [Grunkwork.io](https://github.com/gruntwork-io/terraform-google-gke) for how this module is referenced to.
