#!/usr/bin/env bash
set -e

echo "Syncing LineageOS sources..."

# Check if lineage-sources directory exists
if [ ! -d "lineage-sources" ]; then
    echo "Error: lineage-sources directory not found. Run setup-sources.sh first."
    exit 1
fi

cd lineage-sources

# Check if .repo exists
if [ ! -d ".repo" ]; then
    echo "Error: LineageOS sources not initialized. Run setup-sources.sh first."
    exit 1
fi

echo "Updating LineageOS source tree..."
repo sync -c -j4 --force-sync --no-clone-bundle --no-tags --retry-fetches=3

echo "Source sync complete!"
echo "Note: If you have applied patches, you may need to reapply them after syncing."