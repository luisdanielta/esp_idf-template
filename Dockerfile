FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

# Arguments to customize the image build
ARG IDF_CLONE_URL=https://github.com/espressif/esp-idf.git
ARG IDF_CLONE_BRANCH_OR_TAG=master
ARG IDF_CHECKOUT_REF=
ARG IDF_CLONE_SHALLOW=
ARG IDF_CLONE_SHALLOW_DEPTH=1
ARG IDF_INSTALL_TARGETS=esp32

# Environment variables for ESP-IDF
ENV IDF_PATH=/opt/esp/idf
ENV IDF_TOOLS_PATH=/opt/esp

# Update and install required packages
# This includes build tools, libraries, and utilities needed for ESP-IDF
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-utils \
        bison \
        bzip2 \
        ca-certificates \
        ccache \
        check \
        curl \
        flex \
        git \
        git-lfs \
        gperf \
        lcov \
        libbsd-dev \
        libffi-dev \
        libglib2.0-0 \
        libncurses-dev \
        libpixman-1-0 \
        libsdl2-2.0-0 \
        libslirp0 \
        libusb-1.0-0-dev \
        make \
        ninja-build \
        python3 \
        python3-venv \
        ruby \
        unzip \
        wget \
        xz-utils \
        zip && \
    # Install additional build tools if required for all targets
    if [ "$IDF_INSTALL_TARGETS" = "all" ]; then \
        apt-get install -y --no-install-recommends build-essential; \
    fi && \
    # Clean up to reduce image size
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Set Python 3 as the default Python interpreter
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10

# Clone the ESP-IDF repository
# Clone the specified branch, tag, or reference as per provided arguments
RUN echo IDF_CHECKOUT_REF=$IDF_CHECKOUT_REF IDF_CLONE_BRANCH_OR_TAG=$IDF_CLONE_BRANCH_OR_TAG && \
    git clone --recursive \
        ${IDF_CLONE_SHALLOW:+--depth=${IDF_CLONE_SHALLOW_DEPTH} --shallow-submodules} \
        ${IDF_CLONE_BRANCH_OR_TAG:+-b $IDF_CLONE_BRANCH_OR_TAG} \
        $IDF_CLONE_URL $IDF_PATH && \
    git config --system --add safe.directory $IDF_PATH && \
    # Optionally check out a specific reference
    if [ -n "$IDF_CHECKOUT_REF" ]; then \
        cd $IDF_PATH && \
        if [ -n "$IDF_CLONE_SHALLOW" ]; then \
            git fetch origin --depth=${IDF_CLONE_SHALLOW_DEPTH} --recurse-submodules ${IDF_CHECKOUT_REF}; \
        fi && \
        git checkout $IDF_CHECKOUT_REF && \
        git submodule update --init --recursive; \
    fi

# Install ESP-IDF tools
# This includes required compilers, CMake, QEMU, and Python environment setup
RUN update-ca-certificates --fresh && \
    $IDF_PATH/tools/idf_tools.py --non-interactive install required --targets=${IDF_INSTALL_TARGETS} && \
    $IDF_PATH/tools/idf_tools.py --non-interactive install qemu* --targets=${IDF_INSTALL_TARGETS} && \
    $IDF_PATH/tools/idf_tools.py --non-interactive install cmake && \
    $IDF_PATH/tools/idf_tools.py --non-interactive install-python-env && \
    # Clean up downloaded files to reduce image size
    rm -rf $IDF_TOOLS_PATH/dist

# Add alias for easier use of ESP-IDF
# The alias allows users to easily initialize the ESP-IDF environment
RUN echo 'alias get_idf=". /opt/esp/idf/export.sh"' >> /root/.bashrc

# Configure additional environment variables
# Disable Python constraint checks and enable ccache to speed up builds
ENV IDF_PYTHON_CHECK_CONSTRAINTS=no
ENV IDF_CCACHE_ENABLE=1

# Copy the entrypoint script and make it executable
COPY entrypoint.sh /opt/esp/entrypoint.sh
RUN chmod +x /opt/esp/entrypoint.sh

# Set the working directory
WORKDIR /workspace

# Set the default entrypoint and command
ENTRYPOINT [ "/opt/esp/entrypoint.sh" ]
CMD [ "/bin/bash" ]