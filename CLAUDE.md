# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Homebrew tap for the `sindr` CLI tool - a project-specific command runner. The repository follows standard Homebrew tap conventions with formulas defined in the `Formula/` directory.

## Key Commands

### Updating to Latest Release
```bash
./bump-formula.sh
```
Automatically updates the formula to the latest GitHub release:
- Fetches latest release tag from GitHub API
- Downloads and calculates SHA256 hash
- Updates the formula file
- Provides summary of changes

### Testing the Tap
```bash
./test-tap.sh
```
This comprehensive test script validates the entire tap workflow:
- Adds the local tap to Homebrew
- Audits the formula for issues
- Tests installation (dry run and actual)
- Verifies the binary works (`sindr --help`)
- Tests uninstallation
- Cleans up the tap

### Manual Homebrew Operations
```bash
# Add tap locally for testing
brew tap $(whoami)/homebrew-tap $(pwd)

# Install from local tap
brew install $(whoami)/homebrew-tap/sindr

# Audit formula
brew audit $(whoami)/homebrew-tap/sindr

# Clean up
brew untap $(whoami)/homebrew-tap
```

## Architecture

The repository contains:
- `Formula/sindr.rb`: Homebrew formula that builds the Go binary from source
- `test-tap.sh`: Complete integration test for the tap
- `bump-formula.sh`: Script to automatically update formula to latest release
- `sindr.star`: Empty file (likely placeholder)

The formula downloads source code from GitHub releases and builds using Go. It includes a simple test that runs `--help` to verify the binary works.

## Formula Structure

The `sindr` formula:
- Downloads source from GitHub releases (currently v0.0.6)
- Requires Go as a build dependency
- Builds with optimized flags (`-ldflags "-s -w"`)
- Installs binary to standard Homebrew bin directory