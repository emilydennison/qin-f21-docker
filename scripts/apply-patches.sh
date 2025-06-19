#!/usr/bin/env bash
set -e

# Get the script directory and repository root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Applying dumbdroid patches to LineageOS sources..."
echo "Repository root: $REPO_ROOT"

# Change to repository root
cd "$REPO_ROOT"

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
if [ -d "$REPO_ROOT/dumbdroid_patches" ]; then
    echo "Applying dumbdroid patches..."
    
    find "$REPO_ROOT/dumbdroid_patches" -name "*.patch" | while read patch; do
        # Extract target path from patch location
        target_dir=$(dirname "$patch" | sed "s|^$REPO_ROOT/dumbdroid_patches/||")
        
        echo "Processing patch: $patch"
        echo "Target directory: $target_dir"
        
        if [ -d "$target_dir" ]; then
            echo "✅ Target directory exists: $target_dir"
            
            # Check if this is a git repository
            if [ -d "$target_dir/.git" ]; then
                echo "✅ Git repository found in $target_dir"
                cd "$target_dir"
                
                # Show current git status
                echo "Current git status in $target_dir:"
                git status --porcelain | head -3
                
                # Reset to clean state if there are uncommitted changes
                if ! git diff-index --quiet HEAD --; then
                    echo "⚠️  Uncommitted changes found, resetting to clean state"
                    git reset --hard HEAD
                fi
                
                # Apply the patch with 3-way merge to handle conflicts better
                echo "Applying patch: $(basename "$patch")"
                if git apply --3way "$patch"; then
                    echo "✅ Successfully applied $patch"
                    
                    # Show what changed
                    git diff --name-only HEAD
                    
                    # Add and commit changes
                    git add -A
                    if git commit -m "Apply $(basename "$patch")"; then
                        echo "✅ Committed changes for $(basename "$patch")"
                    else
                        echo "⚠️  No changes to commit for $(basename "$patch")"
                    fi
                else
                    echo "❌ Failed to apply $patch"
                fi
                
                cd - > /dev/null
            else
                echo "❌ No git repository in $target_dir"
            fi
        else
            echo "❌ Target directory $target_dir does not exist"
        fi
        echo "---"
    done
    
    # Mark patches as applied
    touch .patches_applied
    echo "All dumbdroid patches applied successfully!"
else
    echo "No dumbdroid_patches directory found"
fi

cd "$REPO_ROOT"
echo "Patch application complete!"