# CI Workflows

Three workflows test the different ways to install and build mvox with Guix.
Each mirrors a real user workflow documented in the project README.

## guix-install-local.yml — Guix Install (local)

Tests the package definitions in this repo using `guix build -L .` and `guix install -L .`.
Loads packages directly from the local checkout without going through the channel.
This is the fastest way to verify changes to package definitions.

Runs on: push, pull requests, weekly, manual dispatch.

## guix-install-channel.yml — Guix Install (channel)

Tests the end-user channel install flow.
Configures the mvox channel in `channels.scm`, runs `guix pull`, then `guix install mvox`.
Verifies that the channel works as documented in the README.

Runs on: push, weekly, manual dispatch.
Does not run on pull requests since the channel points to main.

## guix-build-source.yml — Guix Build from Source

Tests building mvox from source using `guix shell -D` for dependencies.
Provides build inputs (MFEM, ITK, cmake, etc.) via Guix, then builds with cmake and make.
This is how a developer would build mvox locally.

Runs on: push, pull requests, weekly, manual dispatch.
