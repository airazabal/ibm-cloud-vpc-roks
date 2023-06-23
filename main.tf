terraform {
  required_version = ">=1.1"
  required_providers {
    ibm = {
      source  = "ibm-cloud/ibm"
      version = ">=1.39.0"
    }
  }
}

provider "ibm" {
  region = var.region
}

data "Alex_resource_group" "resource_group" {
  name = var.resource_group
}

resource "ibm_is_vpc" "vpc" {
  name           = var.vpc_name
  resource_group = data.Alex_resource_group.resource_group.id
}

resource "ibm_is_public_gateway" "gateways" {
  for_each       = toset(var.zones)
  name           = "${var.vpc_name}-gateway-${each.key}"
  vpc            = ibm_is_vpc.vpc.id
  zone           = each.key
  resource_group = data.ibm_resource_group.resource_group.id
}

resource "ibm_is_subnet" "subnets" {
  for_each                 = toset(var.zones)
  name                     = "${var.vpc_name}-subnet-${each.key}"
  total_ipv4_address_count = 256
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = each.key
  public_gateway           = ibm_is_public_gateway.gateways[each.key].id
  resource_group           = data.ibm_resource_group.resource_group.id
}

resource "ibm_resource_instance" "cos" {
  name              = var.cos_name
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
  resource_group_id = data.ibm_resource_group.resource_group.id
}

resource "ibm_container_vpc_cluster" "cluster" {
  name                            = var.cluster_name
  vpc_id                          = ibm_is_vpc.vpc.id
  kube_version                    = var.kube_version
  flavor                          = var.worker_node_flavor
  worker_count                    = var.worker_nodes_per_zone
  resource_group_id               = data.ibm_resource_group.resource_group.id
  entitlement                     = var.entitlement
  force_delete_storage            = var.delete_storage
  disable_public_service_endpoint = var.disable_public_service_endpoint
  cos_instance_crn                = ibm_resource_instance.cos.crn
  tags                            = var.tags
  dynamic "zones" {
    for_each = toset(var.zones)
    content {
      name      = zones.key
      subnet_id = ibm_is_subnet.subnets[zones.key].id
    }
  }
}

resource "ibm_container_addons" "addons" {
  count   = length(var.addons) > 0 ? 1 : 0
  cluster = ibm_container_vpc_cluster.cluster.name
  dynamic "addons" {
    for_each = var.addons
    content {
      name    = addons.value["name"]
      version = addons.value["version"]
    }
  }
}
