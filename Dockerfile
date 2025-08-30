FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=lineage
ENV CCACHE_DIR=/tmp/ccache
ENV CCACHE_EXEC=/usr/bin/ccache
ENV USE_CCACHE=1

# Install build dependencies
RUN apt-get update && apt-get install -y \
    bc \
    bison \
    build-essential \
    ccache \
    curl \
    flex \
    g++-multilib \
    gcc-multilib \
    git \
    git-lfs \
    gnupg \
    gperf \
    imagemagick \
    lib32ncurses5-dev \
    lib32readline-dev \
    lib32z1-dev \
    libelf-dev \
    liblz4-tool \
    libncurses5 \
    libncurses5-dev \
    libsdl1.2-dev \
    libssl-dev \
    libxml2 \
    libxml2-utils \
    lzop \
    pngcrush \
    rsync \
    schedtool \
    squashfs-tools \
    xsltproc \
    zip \
    zlib1g-dev \
    python3 \
    python3-pip \
    wget \
    unzip \
    sudo \
    vim \
    default-jre \
    default-jdk \
    libncurses5 \
    && rm -rf /var/lib/apt/lists/*

# Install repo command
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && \
    chmod a+x /usr/local/bin/repo

# Create user for building
RUN useradd -m -s /bin/bash $USER && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER $USER
WORKDIR /home/$USER

# Set up git configuration
RUN git config --global user.email "build@lineageos.org" && \
    git config --global user.name "LineageOS Builder"

# Create build directory - this will be mounted as volume
RUN mkdir -p /home/$USER/lineage-build
WORKDIR /home/$USER/lineage-build

# Set up ccache
RUN ccache -M 50G

# Initialization script removed - sources managed locally

# Patch application script removed - patches applied locally

# Create simplified build script (sources managed locally)
RUN echo '#!/bin/bash' > /home/$USER/build.sh && \
    echo 'set -e' >> /home/$USER/build.sh && \
    echo 'cd /home/$USER/lineage-build' >> /home/$USER/build.sh && \
    echo '# Check if sources are present' >> /home/$USER/build.sh && \
    echo 'if [ ! -d ".repo" ]; then' >> /home/$USER/build.sh && \
    echo '    echo "Error: LineageOS sources not found. Please run setup-sources.sh on host first."' >> /home/$USER/build.sh && \
    echo '    exit 1' >> /home/$USER/build.sh && \
    echo 'fi' >> /home/$USER/build.sh && \
    echo '# Run the unified build script' >> /home/$USER/build.sh && \
    echo 'bash lineage_build_unified/buildbot_unified.sh treble 64VN 64GN' >> /home/$USER/build.sh && \
    chmod +x /home/$USER/build.sh

# Fix permissions on directories so it's owned by lineage and not the 1001 user

RUN sudo chown -R lineage ~/lineage_build_unified

# Default command
CMD ["/bin/bash"]
