provider "azurerm" {
  features {}
}

locals {
  tags = {
    Environment = "Dev"
  }
}

resource "random_id" "suffix" {
  byte_length = 8
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = local.tags
}

module "network" {
  source = "github.com/equinor/terraform-azurerm-network?ref=v3.0.0"

  vnet_name           = "vnet-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_spaces      = ["10.0.0.0/16"]

  subnets = {
    "vm" = {
      name             = "snet-vm-${random_id.suffix.hex}"
      address_prefixes = ["10.0.1.0/24"]
      network_security_group = {
        id = azurerm_network_security_group.example.id
      }
    }
  }

  tags = local.tags
}

module "vm" {
  # source = "github.com/equinor/terraform-azurerm-vm?ref=v0.0.0"
  source = "../.."

  vm_name             = "vm-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_username      = "azureadminuser"
  os_disk_name        = "osdisk-vm-${random_id.suffix.hex}"

  network_interfaces = {
    "backend" = {
      name = "nic-vm-${random_id.suffix.hex}"
      ip_configurations = [
        {
          name      = "ipconfig1"
          subnet_id = module.network.subnet_ids["vm"]
        }
      ]
    }
  }

  tags = local.tags
}
