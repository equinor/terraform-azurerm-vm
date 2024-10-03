# Changelog

## [0.10.0](https://github.com/equinor/terraform-azurerm-vm/compare/v0.9.2...v0.10.0) (2024-10-03)


### Features

* add disk encryption settings ([#54](https://github.com/equinor/terraform-azurerm-vm/issues/54)) ([f90c362](https://github.com/equinor/terraform-azurerm-vm/commit/f90c362a54742a07b46b1104426c8a04c930fe3d))

## [0.9.2](https://github.com/equinor/terraform-azurerm-vm/compare/v0.9.1...v0.9.2) (2024-08-27)


### Documentation

* add features list to README ([#52](https://github.com/equinor/terraform-azurerm-vm/issues/52)) ([fd4c463](https://github.com/equinor/terraform-azurerm-vm/commit/fd4c463fa638aea7a81f82897b8c45f52ddb6ce7))

## [0.9.1](https://github.com/equinor/terraform-azurerm-vm/compare/v0.9.0...v0.9.1) (2024-08-26)


### Miscellaneous Chores

* update variable descriptions ([#50](https://github.com/equinor/terraform-azurerm-vm/issues/50)) ([14a7e91](https://github.com/equinor/terraform-azurerm-vm/commit/14a7e91fcbda79e2943fb91703513ebd74c79f95))

## [0.9.0](https://github.com/equinor/terraform-azurerm-vm/compare/v0.8.0...v0.9.0) (2024-04-11)


### Features

* add license_type ([#45](https://github.com/equinor/terraform-azurerm-vm/issues/45)) ([9356124](https://github.com/equinor/terraform-azurerm-vm/commit/935612404414032da74f68019aa7f96f5fc5fd98))

## [0.8.0](https://github.com/equinor/terraform-azurerm-vm/compare/v0.7.0...v0.8.0) (2024-04-09)


### Features

* add availability_set_id ([#43](https://github.com/equinor/terraform-azurerm-vm/issues/43)) ([51a8750](https://github.com/equinor/terraform-azurerm-vm/commit/51a8750cb9a1efe23865f4af54c3dfea849b6b88))

## [0.7.0](https://github.com/equinor/terraform-azurerm-vm/compare/v0.6.0...v0.7.0) (2024-04-09)


### Features

* configure patch mode ([#41](https://github.com/equinor/terraform-azurerm-vm/issues/41)) ([57c1840](https://github.com/equinor/terraform-azurerm-vm/commit/57c18403590322dfc41454dbf905c91501e82423))

## [0.6.0](https://github.com/equinor/terraform-azurerm-vm/compare/v0.5.0...v0.6.0) (2024-04-04)


### Features

* add variable `os_disk_size_gb` ([#38](https://github.com/equinor/terraform-azurerm-vm/issues/38)) ([8047d2f](https://github.com/equinor/terraform-azurerm-vm/commit/8047d2f67d6a1feae66a0147f26334a162c847d4))

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
