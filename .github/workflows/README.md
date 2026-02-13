# CI Workflows

Three workflows test the different ways to build and install mvox with Guix.
Each mirrors a real user workflow and serves as executable documentation.

## guix-build.yml

Build and install mvox using local package definitions.
Runs `guix build -L .` and `guix install -L .` to test the package
definitions in this repo without publishing them to the channel first.
Use this workflow to verify package changes before pushing.

Runs on: push, pull requests, weekly, manual dispatch.

## guix-channel.yml

Install mvox through the Guix channel, as an end user would.
Configures the mvox channel in `channels.scm`, runs `guix pull` to
fetch the channel, then installs mvox with `guix install mvox`.
This verifies that the published channel works correctly.

Runs on: push, weekly, manual dispatch.
Does not run on pull requests since the channel points to main.

## guix-shell.yml

Build mvox from source inside a Guix development environment.
Runs `guix shell -D mvox` to provide all build dependencies
(MFEM, ITK, cmake, etc.), then builds with cmake and make.
This is how a developer would build mvox locally.

Runs on: push, pull requests, weekly, manual dispatch.
