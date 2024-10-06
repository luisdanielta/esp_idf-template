# 📄 ESP-IDF Docker Setup Documentation

This 🛠️ setup provides a 📦 containerized development environment for the ESP-IDF framework using 🐳 Docker and Docker Compose, specifically targeting 🎯 ESP32 microcontrollers. It is based on Espressif's official setup with enhancements for ✨ usability and efficiency.

## 🐋 Dockerfile Overview

The Dockerfile defines the environment used to build the ESP-IDF container:

1. **🖼️ Base Image**: Uses `Ubuntu 24.04` as the base.
2. **🔧 Build Arguments**: Customizes the image with:
   - `IDF_CLONE_URL`: 🌐 ESP-IDF repository URL (default: `https://github.com/espressif/esp-idf.git`).
   - `IDF_CLONE_BRANCH_OR_TAG`: 🌿 Branch or tag to clone (default: `master`).
3. **🌍 Environment Variables**: Sets `IDF_PATH` and `IDF_TOOLS_PATH` for ESP-IDF.
4. **📦 Dependencies**: Installs `git`, `python3`, `make`, and other required libraries.
5. **🔄 Repository Cloning**: Clones the ESP-IDF repository.
6. **🛠️ Tool Installation**: Uses `idf_tools.py` to install tools for 🎯 ESP32.
7. **🔗 Alias Setup**: Adds an alias to activate ESP-IDF easily.
8. **🏁 Entrypoint Script**: Copies `entrypoint.sh` for container startup.

### ⚡ Quick Usage with Dockerfile

To build and run the 🐳 Docker container:

```sh
🐚 docker build -t esp-idf-image .
🐚 docker run -it --rm esp-idf-image
```

This provides an interactive 🖥️ shell with ESP-IDF tools.

## 🐳 Docker Compose Configuration

The Docker Compose file (`version: '3'`) defines the following:

### 📜 Services

- **`esp-idf`**: Defines the ESP-IDF 🛠️ service.
  - **`build: .`**: Builds the Docker 🐳 image.
  - **`image: esp-idf`**: Assigns the name `esp-idf` to the image.
  - **`container_name: esp-idf-container`**: Names the container.
  - **`volumes`**:
    - **`.`**: Mounts the current 📂 directory to `/workspace`.
    - **`esp-idf-tools`**: Stores ESP-IDF tools persistently.
  - **`🌍 environment`**: Sets `IDF_PATH` and `IDF_TOOLS_PATH`.
  - **`tty: true`** and **`stdin_open: true`**: Keeps the terminal 🖥️ open for interaction.
  - **`command: /bin/bash`**: Sets the default command.

### 📦 Volumes

- **`esp-idf-tools`**: Defines a named volume for ESP-IDF tools.

## ⚡ Quick Usage with Docker Compose

1. **🏗️ Build and 🚀 Start the Container**:
   ```sh
   🐚 docker-compose up -d
   ```

2. **🔌 Access the Container**:
   ```sh
   🐚 docker exec -it esp-idf-container /bin/bash
   ```

This provides an interactive 🖥️ shell within the container.

## 🛠️ Practical Development Workflow

1. **🏁 Make Entrypoint Executable**:
   ```sh
   🐚 chmod +x entrypoint.sh
   ```

2. **🔌 Access the Container**:
   ```sh
   🐚 docker exec -it esp-idf-container /bin/bash
   ```

3. **🔄 Initialize ESP-IDF Environment**:
   ```sh
   🐚 get_idf
   ```

4. **🆕 Create a New Project**:
   ```sh
   🐚 idf.py create-project firmware
   ```

5. **📂 Change Directory and Adjust 📝 Permissions**:
   ```sh
   🐚 cd firmware
   🐚 sudo chown -R $USER:$USER /home/luist/esp_secureRF/firmware
   ```

6. **🎯 Set Target for ESP-IDF**:
   ```sh
   🐚 idf.py set-target esp32
   ```

## 📝 Command Guide Summary

1. **🏁 Make Entrypoint Executable**:
   - `chmod +x entrypoint.sh`

2. **🔌 Access the ESP-IDF Container**:
   - `docker exec -it esp-idf-container /bin/bash`

3. **🔄 Initialize ESP-IDF Environment**:
   - `get_idf`

4. **🆕 Create a New Project**:
   - `idf.py create-project firmware`

5. **📂 Change to Project Directory and Fix 📝 Permissions**:
   - `cd firmware`
   - `sudo chown -R $USER:$USER /home/<username>/<workspace>/firmware`

6. **🎯 Set Target for Development**:
   - `idf.py set-target esp32`

## 🗒️ Notes

- The `volumes` section ensures that ESP-IDF tools are preserved across sessions, reducing 🕒 setup time.
- 🌍 Environment variables are configured to simplify ESP-IDF setup.
- These 🐚 commands provide a streamlined workflow for efficient ESP32 firmware development.

This setup effectively manages ESP-IDF environment initialization, project creation, and 🛠️ development within a containerized structure, ensuring a reproducible and optimized process for ⚡ productivity and maintainability.