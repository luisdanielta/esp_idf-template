FROM codercom/code-server:4.92.2-focal
USER root

# Set environment variables for ESP-IDF
ENV IDF_PATH=/opt/esp/idf
ENV IDF_TOOLS_PATH=/opt/esp

# ARG to set the installation target, default to esp32
ARG IDF_INSTALL_TARGETS=esp32

# Update and install basic utilities
RUN apt-get update
RUN apt-get install -y --no-install-recommends sudo nano apt-utils ca-certificates curl wget unzip zip xz-utils
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Install development tools
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential make ninja-build ccache git git-lfs
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Install debugging and testing tools
RUN sudo apt-get update
RUN sudo apt-get install -y --no-install-recommends check lcov gperf
RUN sudo apt-get autoremove -y
RUN sudo apt-get clean
RUN sudo rm -rf /var/lib/apt/lists/*

# Install system libraries
RUN apt-get update
RUN apt-get install -y --no-install-recommends libbsd-dev libffi-dev libglib2.0-0 libncurses-dev libpixman-1-0 libsdl2-2.0-0 libslirp0 libusb-1.0-0-dev
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Install Python development tools
RUN apt-get update
RUN apt-get install -y --no-install-recommends python3 python3-venv python3-pip
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Install compilation tools
RUN apt-get update
RUN apt-get install -y --no-install-recommends bison bzip2 flex
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Clone the ESP-IDF repository
RUN git clone -b v5.3 --recursive --depth=1 https://github.com/espressif/esp-idf.git $IDF_PATH
RUN git config --system --add safe.directory $IDF_PATH
#RUN git fetch origin --depth=1 --recurse-submodules
#RUN git checkout
#RUN git submodule update --init --recursive

# Install ESP-IDF tools and Python environment, with specified targets
RUN update-ca-certificates --fresh
RUN $IDF_PATH/tools/idf_tools.py --non-interactive install qemu* --targets=${IDF_INSTALL_TARGETS}
RUN $IDF_PATH/tools/idf_tools.py --non-interactive install cmake

RUN $IDF_PATH/tools/idf_tools.py --non-interactive install required --targets=${IDF_INSTALL_TARGETS}
RUN $IDF_PATH/tools/idf_tools.py --non-interactive install-python-env
#RUN rm -rf $IDF_TOOLS_PATH/dist

# Add alias for easier use of ESP-IDF
# The alias allows users to easily initialize the ESP-IDF environment
RUN echo 'alias get_idf=". /opt/esp/idf/export.sh"' >> /root/.bashrc