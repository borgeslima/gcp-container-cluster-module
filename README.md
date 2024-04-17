# GCP GKE Terraform module

Terraform module which creates GKE resources on GCP.


## Usage

```hcl
################################################################################
# VARIABLES LOCAL
################################################################################

locals {
  name    = "quark-labs"
  region  = "us-east1"
  project = "quarks-labs"
}

################################################################################
# NETWORK
################################################################################


module "network" {
  source = "git::https://github.com/quarks-labs/gcp-container-cluster-module.git"
  region                  = local.region
  name                    = local.name
  project                 = local.project
  auto_create_subnetworks = true

  subnetworks = [{
      name                     = "default-01"
      region                   = "us-east1"
      ip_cidr_range            = "172.28.0.0/27"
      private_ip_google_access = false
      nat = {
        nat_ip_allocate_option             = "MANUAL_ONLY"
        source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
      }
      secondary_ip_ranges = [
        {
          range_name    = "primary"
          ip_cidr_range = "172.1.16.0/20"
        },
        {
          range_name    = "secondary"
          ip_cidr_range = "172.1.32.0/20"
        }
      ]
    }
  ]
}

################################################################################
# GKE
################################################################################


module "gke" {
  source                      = "git::https://github.com/quarks-labs/gcp-container-cluster-module.git"
  region                      = local.region
  name                        = local.name
  project                     = local.project
  initial_node_count          = 1
  remove_default_node_pool    = true
  network                     = module.network.network_self_link
  subnetwork                  = module.network.subnetwork_self_link[0]
  default_max_pods_per_node   = 110
  enable_intranode_visibility = false
  enable_l4_ilb_subsetting    = true


  master_auth = {
    client_certificate_config = {
      issue_client_certificate = true
    }
  }

  addons_config = {
    gce_persistent_disk_csi_driver_config = {
      enabled = true
    }
    http_load_balancing = {
      disable = false
    }
    network_policy_config = {
      disabled = false
    }
  }

  enable_kubernetes_alpha = false
  enable_legacy_abac      = true

  network_policy = {
    enabled  = true
    provider = "CALICO"
  }

  private_cluster_config = {
    enable_private_endpoint = false
    enable_private_nodes    = false
    master_ipv4_cidr_block  = ""
    master_global_access_config = {
      enabled = false
    }
  }

  ip_allocation_policy = {
    cluster_secondary_range_name  = tostring([for ips in module.network.subnetwork_secondary_ip_ranges : ips][0][0])
    services_secondary_range_name = tostring([for ips in module.network.subnetwork_secondary_ip_ranges : ips][0][1])
  }

  maintenance_policy = {
    daily_maintenance_window = {
        start_time = "03:00"
    }
  }

  node_pools = [{
    name       = "node-pool-01"
    node_count = 1
    autoscaling = {
      total_min_node_count = 1
      total_max_node_count = 3
      location_policy      = "BALANCED"
    }
    node_config = {
      machine_type = "n1-standard-1"
      disk_type    = "pd-ssd"
      disk_size_gb = 20
      preemptible  = false
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
      ]
      tags = []
      metadata = {}
      labels = {}
    }
    timeouts = {
      create = "30m"
      update = "30m"
    }
  }]
}

data "google_client_config" "provider" {}

```


## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/terraform-gcp-modules/.../issues/new) section.

Full contributing [guidelines are covered here](.github/contributing.md).




<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.24.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_container_cluster.this](https://registry.terraform.io/providers/hashicorp/google/5.24.0/docs/resources/container_cluster) | resource |
| [google_container_node_pool.this](https://registry.terraform.io/providers/hashicorp/google/5.24.0/docs/resources/container_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addons_config"></a> [addons\_config](#input\_addons\_config) | n/a | <pre>object({<br>    http_load_balancing = object({<br>      disable = bool<br>    })<br>    gce_persistent_disk_csi_driver_config = object({<br>      enabled = bool<br>    })<br>    network_policy_config = object({<br>      disabled = bool<br>    })<br>  })</pre> | <pre>{<br>  "gce_persistent_disk_csi_driver_config": {<br>    "enabled": true<br>  },<br>  "http_load_balancing": {<br>    "disable": false<br>  },<br>  "network_policy_config": {<br>    "disabled": false<br>  }<br>}</pre> | no |
| <a name="input_default_max_pods_per_node"></a> [default\_max\_pods\_per\_node](#input\_default\_max\_pods\_per\_node) | n/a | `number` | n/a | yes |
| <a name="input_enable_intranode_visibility"></a> [enable\_intranode\_visibility](#input\_enable\_intranode\_visibility) | n/a | `bool` | n/a | yes |
| <a name="input_enable_kubernetes_alpha"></a> [enable\_kubernetes\_alpha](#input\_enable\_kubernetes\_alpha) | n/a | `bool` | n/a | yes |
| <a name="input_enable_l4_ilb_subsetting"></a> [enable\_l4\_ilb\_subsetting](#input\_enable\_l4\_ilb\_subsetting) | n/a | `bool` | n/a | yes |
| <a name="input_enable_legacy_abac"></a> [enable\_legacy\_abac](#input\_enable\_legacy\_abac) | n/a | `bool` | n/a | yes |
| <a name="input_initial_node_count"></a> [initial\_node\_count](#input\_initial\_node\_count) | n/a | `number` | n/a | yes |
| <a name="input_ip_allocation_policy"></a> [ip\_allocation\_policy](#input\_ip\_allocation\_policy) | n/a | <pre>object({<br>    cluster_secondary_range_name  = string<br>    services_secondary_range_name = string<br>  })</pre> | n/a | yes |
| <a name="input_maintenance_policy"></a> [maintenance\_policy](#input\_maintenance\_policy) | n/a | <pre>object({<br>    daily_maintenance_window = object({<br>      start_time = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_master_auth"></a> [master\_auth](#input\_master\_auth) | n/a | <pre>object({<br>     client_certificate_config = object({<br>      issue_client_certificate = bool<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of GCP Network | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | network | `any` | n/a | yes |
| <a name="input_network_policy"></a> [network\_policy](#input\_network\_policy) | n/a | <pre>object({<br>    enabled = bool<br>    provider = string<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "provider": "CALICO"<br>}</pre> | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | n/a | <pre>list(object({<br>    name                    = string<br>    node_count              = number<br>    autoscaling             = object({<br>      total_min_node_count = number<br>      total_max_node_count = number<br>      location_policy      = string<br>    })<br>    node_config             = object({<br>      machine_type   = string<br>      disk_type      = string<br>      disk_size_gb   = number<br>      preemptible    = bool<br>      oauth_scopes   = set(string)<br>      tags           = list(string)<br>      metadata       = map(string)<br>      labels         = map(string)<br>    })<br>    timeouts                = object({<br>      create = string<br>      update = string<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_private_cluster_config"></a> [private\_cluster\_config](#input\_private\_cluster\_config) | n/a | <pre>object({<br>    enable_private_endpoint = bool<br>    enable_private_nodes    = bool<br>    master_ipv4_cidr_block  = string<br>    master_global_access_config = object({<br>      enabled = bool<br>    })<br>  })</pre> | <pre>{<br>  "enable_private_endpoint": false,<br>  "enable_private_nodes": false,<br>  "master_global_access_config": {<br>    "enabled": false<br>  },<br>  "master_ipv4_cidr_block": ""<br>}</pre> | no |
| <a name="input_project"></a> [project](#input\_project) | Name of GCP Network | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP Region | `string` | n/a | yes |
| <a name="input_remove_default_node_pool"></a> [remove\_default\_node\_pool](#input\_remove\_default\_node\_pool) | n/a | `bool` | n/a | yes |
| <a name="input_service_external_ips_config"></a> [service\_external\_ips\_config](#input\_service\_external\_ips\_config) | n/a | <pre>object({<br>    enabled = bool<br>  })</pre> | <pre>{<br>  "enabled": false<br>}</pre> | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | List of GCP Subnetworks | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | n/a |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->





