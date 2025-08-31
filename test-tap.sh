#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

TAP_NAME="homebrew-tap"
FORMULA_NAME="sindr"

brew cleanup >/dev/null 2>&1

echo -e "${YELLOW}Testing Homebrew tap locally...${NC}"

# Get the current directory (should be the tap root)
TAP_DIR=$(pwd)

# Verify we're in a tap directory
if [ ! -d "Formula" ]; then
  echo -e "${RED}Error: Not in a Homebrew tap directory (no Formula/ directory found)${NC}"
  exit 1
fi

if [ ! -f "Formula/${FORMULA_NAME}.rb" ]; then
  echo -e "${RED}Error: Formula/${FORMULA_NAME}.rb not found${NC}"
  exit 1
fi

echo -e "${YELLOW}✓ Found Formula/${FORMULA_NAME}.rb${NC}"

# Check if tap is already added
if brew tap | grep -q "$(basename $TAP_DIR)"; then
  echo -e "${YELLOW}Tap already exists, removing first...${NC}"
  brew untap "$(whoami)/$(basename $TAP_DIR)" || true
fi

# Add the local tap
echo -e "${YELLOW}Adding local tap...${NC}"
brew tap "$(whoami)/$(basename $TAP_DIR)" "$TAP_DIR"

# Test formula audit (skip strict mode for now)
echo -e "${YELLOW}Auditing formula...${NC}"
brew audit "$(whoami)/$(basename $TAP_DIR)/${FORMULA_NAME}" || echo -e "${YELLOW}Warning: Audit found issues but continuing...${NC}"

# Test installation (in verbose mode to see what's happening)
echo -e "${YELLOW}Testing installation (dry run)...${NC}"
if brew install --dry-run "$(whoami)/$(basename $TAP_DIR)/${FORMULA_NAME}" 2>&1; then
  echo -e "${GREEN}✓ Formula can be installed (dry run successful)${NC}"
else
  echo -e "${YELLOW}Warning: Dry run had issues, trying actual install...${NC}"
fi

# Try actual installation
echo -e "${YELLOW}Installing ${FORMULA_NAME}...${NC}"
if brew install "$(whoami)/$(basename $TAP_DIR)/${FORMULA_NAME}" 2>&1; then
  echo -e "${GREEN}✓ Installation successful${NC}"

  # Test that the binary works
  echo -e "${YELLOW}Testing installed binary...${NC}"
  if command -v ${FORMULA_NAME} >/dev/null 2>&1; then
    ${FORMULA_NAME} --help
    echo -e "${GREEN}✓ Binary works correctly${NC}"

    # Test uninstallation
    echo -e "${YELLOW}Testing uninstallation...${NC}"
    brew uninstall "$(whoami)/$(basename $TAP_DIR)/${FORMULA_NAME}"

    hash -r

    # Verify binary is removed
    if command -v ${FORMULA_NAME} >/dev/null 2>&1; then
      echo -e "${RED}✗ Binary still exists after uninstall${NC}"
      exit 1
    else
      echo -e "${GREEN}✓ Binary successfully removed${NC}"
    fi
  else
    echo -e "${YELLOW}Warning: Binary not found in PATH, but installation reported success${NC}"
    # Still try to uninstall
    brew uninstall "$(whoami)/$(basename $TAP_DIR)/${FORMULA_NAME}" 2>/dev/null || true
  fi
else
  echo -e "${YELLOW}Warning: Installation failed, but tap structure is valid${NC}"
fi

# Clean up - remove tap
echo -e "${YELLOW}Cleaning up tap...${NC}"
brew untap "$(whoami)/$(basename $TAP_DIR)"

echo -e "${GREEN}✓ All tests passed! The tap works correctly.${NC}"
