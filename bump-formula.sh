#!/bin/bash

set -e

REPO="mbark/sindr"
FORMULA_FILE="Formula/sindr.rb"

echo "🔍 Fetching latest release from GitHub..."

# Get latest release info
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest")
LATEST_TAG=$(echo "$LATEST_RELEASE" | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')

if [ -z "$LATEST_TAG" ]; then
    echo "❌ Failed to get latest tag from GitHub"
    exit 1
fi

echo "📦 Latest release: $LATEST_TAG"

# Get current version from formula
CURRENT_VERSION=$(grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' "$FORMULA_FILE" | head -1)

if [ "$CURRENT_VERSION" = "$LATEST_TAG" ]; then
    echo "✅ Formula is already up to date ($CURRENT_VERSION)"
    exit 0
fi

echo "🔄 Updating from $CURRENT_VERSION to $LATEST_TAG"

# Download tarball and calculate SHA256
TARBALL_URL="https://github.com/${REPO}/archive/refs/tags/${LATEST_TAG}.tar.gz"
echo "📥 Downloading tarball..."

TEMP_FILE=$(mktemp)
curl -sL "$TARBALL_URL" -o "$TEMP_FILE"

NEW_SHA256=$(shasum -a 256 "$TEMP_FILE" | cut -d' ' -f1)
rm "$TEMP_FILE"

echo "🔑 New SHA256: $NEW_SHA256"

# Update formula file
echo "✏️  Updating formula..."

# Create backup
cp "$FORMULA_FILE" "${FORMULA_FILE}.backup"

# Update URL and SHA256
sed -i '' "s|tags/v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.tar\.gz|tags/${LATEST_TAG}.tar.gz|g" "$FORMULA_FILE"
sed -i '' "s|sha256 \"[^\"]*\"|sha256 \"${NEW_SHA256}\"|g" "$FORMULA_FILE"

echo "✅ Formula updated successfully!"
echo ""
echo "📝 Changes:"
echo "   Version: $CURRENT_VERSION → $LATEST_TAG"
echo "   SHA256:  Updated"
echo ""
echo "🧪 Run './test-tap.sh' to test the updated formula"