# Terraform module for Azure VM

[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![Equinor Terraform Baseline](https://img.shields.io/badge/Equinor%20Terraform%20Baseline-1.0.0-blueviolet)](https://github.com/equinor/terraform-baseline)

Terraform module which creates Azure Virtual Machine resources.

## Development

1. Clone this repository:

    ```console
    git clone https://github.com/equinor/terraform-azurerm-vm.git
    ```

1. Login to Azure:

    ```console
    az login
    ```

1. Set active subscription:

    ```console
    az account set -s <SUBSCRIPTION_NAME_OR_ID>
    ```

1. Set environment variables:

    ```console
    export TF_VAR_resource_group_name=<RESOURCE_GROUP_NAME>
    export TF_VAR_location=<LOCATION>
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
