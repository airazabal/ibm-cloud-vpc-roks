variable "resource_group" {
  type        = string
  default     = "Default"
  description = "Name of the resource group"
}

variable "region" {
  type        = string
  default     = "eu-de"
  description = "Name of the region"
}

variable "zones" {
  type        = list(string)
  default     = ["eu-de-1", "eu-de-2", "eu-de-3"]
  description = "The zones in which the cluster and worker nodes will be installed"
}

variable "vpc_name" {
  type        = string
  default     = "my-vpc"
  description = "Name of the Vitual Private Cloud"
}

variable "cos_name" {
  type        = string
  default     = "openshift-registry"
  description = "Name of the IBM Cloud Object instance"
}

variable "cluster_name" {
  type        = string
  default     = "spitfire"
  description = "Name for the cluster"
}

variable "kube_version" {
  type        = string
  default     = "4.11_openshift"
  description = "The OpenShift version"
}

variable "worker_node_flavor" {
  type        = string
  default     = "bx2.4x16"
  description = "The machine type for the worker nodes"
}

variable "worker_nodes_per_zone" {
  type        = number
  default     = 1
  description = "The number of worker nodes per zone"
}

variable "entitlement" {
  type        = string
  default     = ""
  description = "Entitlement to use for the worker pool"
}

variable "disable_public_service_endpoint" {
  type        = bool
  default     = "false"
  description = "Flag indicating wether to disable the public service endpoint"
}

variable "delete_storage" {
  type        = bool
  default     = "true"
  description = "Flag indicating wether to delete storage when the cluster is deleted"
}

variable "tags" {
  type        = list(string)
  default     = []
  description = "List of tags to add"
}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
  default     = []
  description = "List of addons with the version to enable"
}
