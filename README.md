# promtail

# replace promtail in each badge
![](https://img.shields.io/puppetforge/pdk-version/genebean/promtail.svg?style=popout)
![](https://img.shields.io/puppetforge/v/genebean/promtail.svg?style=popout)
![](https://img.shields.io/puppetforge/dt/genebean/promtail.svg?style=popout)
[![Build Status](https://travis-ci.org/genebean/genebean-promtail.svg?branch=master)](https://travis-ci.org/genebean/genebean-promtail)

> NOTE: This module is currently in the genebean namespace on GitHub instead of Grafana's. The intention is to transfer this repository to them after initial development.

Deploy and configure Grafana's Promtail.

- [Description](#description)
- [Setup](#setup)
  - [What promtail affects **OPTIONAL**](#what-promtail-affects-optional)
  - [Setup Requirements **OPTIONAL**](#setup-requirements-optional)
  - [Beginning with promtail](#beginning-with-promtail)
- [Usage](#usage)
- [Reference](#reference)
- [Changelog](#changelog)
- [Limitations](#limitations)
- [Development](#development)
- [Release Notes/Contributors/Etc. **Optional**](#release-notescontributorsetc-optional)

## Description

[Promtail](https://github.com/grafana/loki/tree/master/docs/clients/promtail) is an agent which ships the contents of local logs to a private [Loki](https://grafana.com/oss/loki) instance or [Grafana Cloud](https://grafana.com/products/cloud). It is usually deployed to every machine that has applications needed to be monitored.

It primarily:

1. Discovers targets
2. Attaches labels to log streams
3. Pushes them to the Loki instance.

Currently, Promtail can tail logs from two sources: local log files and the systemd journal (on AMD64 machines only).

## Setup

### What promtail affects **OPTIONAL**

If it's obvious what your module touches, you can skip this section. For example, folks can probably figure out that your mysql_instance module affects their MySQL instances.

If there's more that they should know about, though, this is the place to mention:

* Files, packages, services, or operations that the module will alter, impact, or execute.
* Dependencies that your module automatically installs.
* Warnings or other important notices.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled, another module, etc.), mention it here.

If your most recent release breaks compatibility or requires particular steps for upgrading, you might want to include an additional "Upgrading" section here.

### Beginning with promtail

The very basic steps needed for a user to get the module up and running. This can include setup steps, if necessary, or it can be an example of the most basic use of the module.

## Usage

Include usage examples for common use cases in the **Usage** section. Show your users how to use your module to solve problems, and be sure to include code examples. Include three to five examples of the most important or common tasks a user can accomplish with your module. Show users how to accomplish more complex tasks that involve different types, classes, and functions working in tandem.

## Reference

This module is documented via
`pdk bundle exec puppet strings generate --format markdown`.
Please see [REFERENCE.md](REFERENCE.md) for more info.

## Changelog

[CHANGELOG.md](CHANGELOG.md) is generated prior to each release via
`pdk bundle exec rake changelog`. This process relies on labels that are applied to each pull request.

## Limitations

In the Limitations section, list any incompatibilities, known issues, or other warnings.

## Development

In the Development section, tell other users the ground rules for contributing to your project and how they should submit their work.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You can also add any additional sections you feel are necessary or important to include here. Please use the `## ` header.
