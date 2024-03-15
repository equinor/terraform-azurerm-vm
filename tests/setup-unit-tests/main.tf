terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }
}

resource "random_id" "name_suffix" {
  byte_length = 8
}

resource "random_uuid" "subscription_id" {}

locals {
  name_suffix           = random_id.name_suffix.hex
  subscription_id       = random_uuid.subscription_id.result
  resource_group_name   = "rg-${local.name_suffix}"
  vm_name               = "vm-${local.name_suffix}"
  os_disk_name          = "osdisk-${local.vm_name}"
  storage_blob_endpoint = "https://stvm${local.name_suffix}.blob.core.windows.net/"
  nic_name              = "nic-${local.vm_name}"
  vnet_name             = "vnet-${local.name_suffix}"
  subnet_name           = "snet-${local.vm_name}"
  subnet_id             = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${local.vnet_name}/subnets/${local.subnet_name}"
}
