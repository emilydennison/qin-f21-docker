#!/usr/bin/env bash
set -e

echo "Applying dumbdroid patches to LineageOS sources..."

# Check if lineage-sources directory exists
if [ ! -d "lineage-sources" ]; then
    echo "Error: lineage-sources directory not found. Run setup-sources.sh first."
    exit 1
fi

# Check if .repo exists
if [ ! -d "lineage-sources/.repo" ]; then
    echo "Error: LineageOS sources not initialized. Run setup-sources.sh first."
    exit 1
fi

cd lineage-sources

# Check if patches were already applied
if [ -f ".patches_applied" ]; then
    echo "Patches already applied. Skipping..."
    exit 0
fi

# Apply dumbdroid patches
if [ -d "../dumbdroid_patches" ]; then
    echo "Applying dumbdroid patches..."
    
    find ../dumbdroid_patches -name "*.patch" | while read patch; do
        # Extract target path from patch location
        target_dir=$(dirname "$patch" | sed 's|^../dumbdroid_patches/||')
        
        if [ -d "$target_dir" ]; then
            echo "Applying $patch to $target_dir"
            cd "$target_dir"
            
            # Create a git branch for tracking patches if this is the first patch for this directory
            if ! git branch | grep -q "dumbdroid-patches"; then
                git checkout -b dumbdroid-patches 2>/dev/null || git checkout dumbdroid-patches
            fi
            
            # Apply the patch
            if git apply "$patch"; then
                echo "Successfully applied $patch"
                # Commit the patch
                git add -A
                git commit -m "Apply $(basename "$patch")" || echo "Nothing to commit for $patch"
            else
                echo "Failed to apply $patch"
            fi
            
            cd - > /dev/null
        else
            echo "Target directory $target_dir does not exist for patch $patch"
        fi
    done
    
    # Mark patches as applied
    touch .patches_applied
    echo "All dumbdroid patches applied successfully!"
else
    echo "No dumbdroid_patches directory found"
fi

cd ..
echo "Patch application complete!"