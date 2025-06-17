# LineageOS Build Environment

This repository contains a complete local setup for building LineageOS using the unified build scripts from [AndyCGYan/lineage_build_unified](https://github.com/AndyCGYan/lineage_build_unified) with custom dumbdroid patches applied.

## Repository Structure

```
├── scripts/                    # Management scripts
│   ├── setup-sources.sh       # Initialize LineageOS sources
│   ├── apply-patches.sh        # Apply dumbdroid patches
│   ├── sync-sources.sh         # Update sources from upstream
│   └── build.sh                # Build LineageOS in Docker
├── lineage_build_unified/      # Build scripts (git submodule)
├── lineage_patches_unified/    # Patch collection (git submodule)
├── dumbdroid_patches/          # Custom patches
├── lineage-sources/            # LineageOS source tree (local, gitignored)
├── build-output/               # Build artifacts
├── Dockerfile                  # Build environment
└── docker-compose.yml          # Container orchestration
```

## Initial Setup

### 1. Clone with submodules:
After you've set up the submodules as instructed, update them:
```bash
git submodule update --init --recursive
```

### 2. Build Docker image:
```bash
docker-compose build
```
### 3. Install `repo` tool:
The `repo` tool is required to initialize and sync LineageOS sources.

```bash
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH
```

To make the `repo` tool available permanently, add the following line to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
export PATH=~/bin:$PATH
```

### 4. Initialize LineageOS sources:

```bash
./scripts/setup-sources.sh
```

### 5. Apply custom patches:

```bash
./scripts/apply-patches.sh
```

## Building LineageOS

### Build everything:
```bash
./scripts/build.sh
```

### Or build interactively:
```bash
docker-compose run --rm lineageos-build
# Inside container:
/home/lineage/build.sh
```

## Workflow

### Daily Development
1. **Update sources**: `./scripts/sync-sources.sh`
2. **Build**: `./scripts/build.sh`

### Managing Patches
- Patches are applied to git branches in each affected component
- Patches create commits with descriptive messages
- Easy to track what changes were made

### Updating Submodules
```bash
git submodule update --remote
git add lineage_build_unified lineage_patches_unified
git commit -m "Update build scripts and patches"
```

## Build Output

Built LineageOS images are available in `build-output/` directory.

## Key Benefits

- **Version Control**: All patches and configurations tracked in git
- **Local Development**: Full source tree available for modification
- **Reproducible**: Anyone can clone and get identical setup
- **Fast Rebuilds**: ccache and local sources speed up development
- **Modular**: Easy to update components independently

## System Requirements

- At least 300GB of free disk space
- 16GB+ RAM recommended  
- Fast internet connection for initial sync
- Docker and docker-compose
