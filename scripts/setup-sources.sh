#!/usr/bin/env bash
set -e

echo "Setting up LineageOS sources..."

# Create the lineage-sources directory if it doesn't exist
mkdir -p lineage-sources

# Enter the source directory
cd lineage-sources

# Initialize repo if not already done
if [ ! -d ".repo" ]; then
    echo "Initializing LineageOS workspace..."
    repo init -u https://github.com/LineageOS/android.git -b lineage-22.2 --git-lfs
else
    echo "Workspace already initialized."
fi

# Sync the sources
echo "Syncing LineageOS source tree (this will take a long time)..."
repo sync -c -j4 --force-sync --no-clone-bundle --no-tags --retry-fetches=3

echo "LineageOS sources setup complete!"
echo "Next step: Run scripts/apply-patches.sh to apply custom patches"