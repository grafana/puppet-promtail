# Promtail

![](https://img.shields.io/puppetforge/pdk-version/grafana/promtail.svg?style=popout)
![](https://img.shields.io/puppetforge/v/grafana/promtail.svg?style=popout)
![](https://img.shields.io/puppetforge/dt/grafana/promtail.svg?style=popout)
[![Build Status](https://github.com/grafana/puppet-promtail/actions/workflows/pr_test.yml/badge.svg?branch=main)](https://github.com/grafana/puppet-promtail/actions/workflows/pr_test.yml)
[![License](https://img.shields.io/github/license/grafana/puppet-promtail?stype=popout)](LICENSE)

Deploy and configure Grafana's Promtail on a node.

- [Description](#description)
- [Usage](#usage)
- [Reference](#reference)
- [Changelog](#changelog)
- [Limitations](#limitations)
- [Development](#development)
- [Module Release](#module-release)

## Description

[Promtail](https://github.com/grafana/loki/tree/master/docs/clients/promtail) is an agent which ships the contents of local logs to a private [Loki](https://grafana.com/oss/loki) instance or [Grafana Cloud](https://grafana.com/products/cloud). It is usually deployed to every machine that has applications needed to be monitored.

It primarily:

1. Discovers targets
2. Attaches labels to log streams
3. Pushes them to the Loki instance.

Currently, Promtail can tail logs from two sources: local log files and the systemd journal (on AMD64 machines only).

## Usage

The simplest way to get started with this module is to add `include promtail` to a manifest and create your config settings in Hiera. Additional details and examples are contained in [REFERENCE.md](REFERENCE.md).

## Reference

This module is documented via
`pdk bundle exec puppet strings generate --format markdown`.
Please see [REFERENCE.md](REFERENCE.md) for more info.

## Changelog

[CHANGELOG.md](CHANGELOG.md) is generated prior to each release via
`pdk bundle exec rake changelog`. This process relies on labels that are applied to each pull request.

## Limitations

At the moment, this module only supports Linux. Future versions will support additional OS's including Windows.

## Development

Pull requests are welcome! A Vagrantfile is also included in this repository that can be used during development.

## Module Release

Follow the steps below to tag a new release and push to The Forge using GitHub Actions.

1. Ensure that all closed PRs are labeled appropriately.
2. Create a "Release Prep" PR with the label "maintenance" containing changes made by the following:
    1. Bump the module version (X.Y.Z) in `metadata.json` as appropriate based on closed PRs since the previous release. (i.e. "backwards-incomptible" is an X "release", "feature" is a Y release, and "bugfix" is a Z release)
    2. Run `pdk bundle exec puppet strings generate --format markdown`. Any missing documentation will result in a failed pipeline.
    3. Run `pdk bundle exec rake changelog`. Any unlabeled PRs will result in a failed pipeline.
3. Once the PR is merged, navigate to Actions --> Publish Module --> Run workflow --> select the main branch, and Run workflow.
