# Changelog

## [0.5.0](https://github.com/equinor/terraform-azurerm-vm/compare/v0.4.0...v0.5.0) (2024-04-03)


### Features

* add variable `admin_password` ([#37](https://github.com/equinor/terraform-azurerm-vm/issues/37)) ([0a15028](https://github.com/equinor/terraform-azurerm-vm/commit/0a15028f07af498f0b2910e24fbf0a9c0c1d85cd))
* associate network interface with security group ([#33](https://github.com/equinor/terraform-azurerm-vm/issues/33)) ([87a0ac6](https://github.com/equinor/terraform-azurerm-vm/commit/87a0ac633f7bba00f21f569adc32e17f0627c8c4))

## [0.4.0](https://github.com/equinor/terraform-azurerm-vm/compare/v0.3.0...v0.4.0) (2024-03-27)


### Features

* added hyper_v_generation parameter to data_disks ([#30](https://github.com/equinor/terraform-azurerm-vm/issues/30)) ([f4231a3](https://github.com/equinor/terraform-azurerm-vm/commit/f4231a3b445f88176908160f95b52cda3711dd60))

## [0.3.0](https://github.com/equinor/terraform-azurerm-vm/compare/v0.2.0...v0.3.0) (2024-03-26)


### Features

* add additional VM tags ([#19](https://github.com/equinor/terraform-azurerm-vm/issues/19)) ([6d5527c](https://github.com/equinor/terraform-azurerm-vm/commit/6d5527c9f8b0ada75e77991fc82054c6bfd730ea)), closes [#13](https://github.com/equinor/terraform-azurerm-vm/issues/13)
* add custom data ([#20](https://github.com/equinor/terraform-azurerm-vm/issues/20)) ([0c74a39](https://github.com/equinor/terraform-azurerm-vm/commit/0c74a39e1afaded3091ca25d95e91547c8aef124))
* create data disks ([#23](https://github.com/equinor/terraform-azurerm-vm/issues/23)) ([3fc517e](https://github.com/equinor/terraform-azurerm-vm/commit/3fc517eaa20f3922752b82622a82c10d2d5c232b))
* enable identity ([#22](https://github.com/equinor/terraform-azurerm-vm/issues/22)) ([a6727bf](https://github.com/equinor/terraform-azurerm-vm/commit/a6727bf6f693b9464af30944886b156ce13d52c5))
* install extensions ([#26](https://github.com/equinor/terraform-azurerm-vm/issues/26)) ([7a67117](https://github.com/equinor/terraform-azurerm-vm/commit/7a67117105966dbe9010f2ace35e4dc2c5b2d96c))


### Bug Fixes

* always mark first IP configuration as primary ([#25](https://github.com/equinor/terraform-azurerm-vm/issues/25)) ([64681c5](https://github.com/equinor/terraform-azurerm-vm/commit/64681c528bc3ecc0eb180e093596077f1a9f80ba))

## [0.2.0](https://github.com/equinor/terraform-azurerm-vm/compare/v0.1.0...v0.2.0) (2024-03-20)


### Features

* output private IP addresses ([#8](https://github.com/equinor/terraform-azurerm-vm/issues/8)) ([1bf3158](https://github.com/equinor/terraform-azurerm-vm/commit/1bf31583121753ffb98496cd8bd60d8ae8502e22))


### Bug Fixes

* configure multiple network interface IPs ([#12](https://github.com/equinor/terraform-azurerm-vm/issues/12)) ([7e54922](https://github.com/equinor/terraform-azurerm-vm/commit/7e54922abc416f1e05135740b18fb0735403cb85))

## 0.1.0 (2024-03-15)


### Features

* create virtual machine ([#3](https://github.com/equinor/terraform-azurerm-vm/issues/3)) ([bd8d5e4](https://github.com/equinor/terraform-azurerm-vm/commit/bd8d5e45d47220aba77054a5e31eed1dbaf0689e))
