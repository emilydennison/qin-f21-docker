#!/usr/bin/env bash
set -e

echo "Starting LineageOS build in Docker container..."

# Check if lineage-sources directory exists
if [ ! -d "lineage-sources" ]; then
    echo "Error: lineage-sources directory not found. Run setup-sources.sh first."
    exit 1
fi

# Check if build output directory exists
mkdir -p build-output

# Run the build in Docker
docker-compose run --rm lineageos-build /home/lineage/build.sh

echo "Build complete! Check build-output/ directory for results."