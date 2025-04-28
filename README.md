# Terraform module for Azure Virtual Machine

[![GitHub License](https://img.shields.io/github/license/equinor/terraform-azurerm-vm)](https://github.com/equinor/terraform-azurerm-vm/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/equinor/terraform-azurerm-vm)](https://github.com/equinor/terraform-azurerm-vm/releases/latest)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![SCM Compliance](https://scm-compliance-api.radix.equinor.com/repos/equinor/terraform-azurerm-vm/badge)](https://developer.equinor.com/governance/scm-policy/)

Terraform module which creates Azure Virtual Machine (VM) resources.

## Features

- Ubuntu (Linux) or Windows Server VM created by default.
- Azure-orchestrated patching enabled by default.
- Boot diagnostics enabled.
- Azure Monitor Agent extension installed.

## Prerequisites

- Azure role `Contributor` at the resource group scope.

## Usage

```terraform
provider "azurerm" {
  storage_use_azuread = true

  features {}
}

module "vm" {
  source = "equinor/vm/azurerm"
  version = "~> 0.11"

  vm_name               = "example-vm"
  resource_group_name   = azurerm_resource_group.example.name
  location              = azurerm_resource_group.example.location
  admin_username        = "azureadminuser"
  os_disk_name          = "example-vm-osdisk"
  storage_blob_endpoint = module.storage.blob_endpoint

  network_interfaces = {
    "example" = {
      name = "example-vm-nic"

      ip_configurations = [
        {
          name      = "ipconfig1"
          subnet_id = module.network.subnet_ids["vm"]
        }
      ]
    }
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}

module "log_analytics" {
  source  = "equinor/log-analytics/azurerm"
  version = "~> 2.4"

  workspace_name      = "example-workspace"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

module "storage" {
  source  = "equinor/storage/azurerm"
  version = "~> 12.12"

  account_name               = "examplevmstorage"
  resource_group_name        = azurerm_resource_group.example.name
  location                   = azurerm_resource_group.example.location
  log_analytics_workspace_id = module.log_analytics.workspace_id
}

module "network" {
  source  = "equinor/network/azurerm"
  version = "~> 3.2"

  vnet_name           = "example-vnet"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_spaces      = ["10.0.0.0/16"]

  subnets = {
    "vm" = {
      name             = "example-vm-snet"
      address_prefixes = ["10.0.1.0/24"]
    }
  }
}
```

## Testing

1. Initialize working directory:

    ```console
    terraform init
    ```

1. Execute tests:

    ```console
    terraform test
    ```

    See [`terraform test` command documentation](https://developer.hashicorp.com/terraform/cli/commands/test) for options.

## Contributing

See [Contributing guidelines](https://github.com/equinor/terraform-baseline/blob/main/CONTRIBUTING.md).
