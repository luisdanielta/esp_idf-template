# Documentation for ESP-IDF Docker Setup

This setup provides a containerized development environment for the ESP-IDF framework using Docker and Docker Compose, primarily targeting ESP32 microcontrollers. It is based on Espressif's official setup with some modifications for ease of use.

## Dockerfile Overview

The Dockerfile defines the environment used to build the ESP-IDF container. Below are the key steps and configurations:

1. **Base Image**: Uses `Ubuntu 24.04` as the base image.
2. **Arguments**: Several build arguments are defined to customize the image:
   - `IDF_CLONE_URL`: URL for the ESP-IDF repository (default: `https://github.com/espressif/esp-idf.git`).
   - `IDF_CLONE_BRANCH_OR_TAG`: Branch or tag to clone (default: `master`).
   - Additional arguments to control cloning depth and targets.
3. **Environment Variables**:
   - `IDF_PATH` and `IDF_TOOLS_PATH` are set to define ESP-IDF paths.
4. **Dependencies Installation**: Installs required packages such as `git`, `python3`, `make`, and various libraries for ESP-IDF development.
5. **Cloning ESP-IDF**: Clones the ESP-IDF repository and optionally checks out specific references.
6. **Tool Installation**: Uses `idf_tools.py` to install required tools for the specified targets (e.g., ESP32).
7. **Alias Setup**: Adds an alias to simplify the activation of ESP-IDF.
8. **Entrypoint**: Copies an entrypoint script (`entrypoint.sh`) for container startup.

### Quick Usage with Dockerfile

To build and run the Docker container manually:

```sh
docker build -t esp-idf-image .
docker run -it --rm esp-idf-image
```

This will provide an interactive shell with ESP-IDF tools set up.

## Docker Compose Configuration

The Docker Compose file (`version: '3'`) defines the following:

### Services

- **`esp-idf`**: Defines the ESP-IDF service.
  - **`build: .`**: Builds the Docker image from the current directory.
  - **`image: esp-idf`**: Names the image `esp-idf`.
  - **`container_name: esp-idf-container`**: Names the container `esp-idf-container`.
  - **`volumes`**:
    - **`.`**: Mounts the current directory to `/workspace` inside the container with read/write permissions.
    - **`esp-idf-tools`**: Persistent volume to store ESP-IDF tools (`/root/.espressif`).
  - **`environment`**: Sets up necessary environment variables:
    - `IDF_PATH=/opt/esp/idf`
    - `IDF_TOOLS_PATH=/opt/esp`
  - **`tty: true`**: Keeps the terminal open.
  - **`stdin_open: true`**: Allows interactive input.
  - **`command: /bin/bash`**: Sets the default command to `/bin/bash`.

### Volumes

- **`esp-idf-tools`**: Named volume for storing ESP-IDF tools, allowing reuse across container runs.

## Quick Usage with Docker Compose

1. **Build and Start the Container**:
   ```sh
   docker-compose up -d
   ```

2. **Access the Container**:
   ```sh
   docker exec -it esp-idf-container /bin/bash
   ```

This will provide you with an interactive shell in the container, ready for ESP-IDF development.

### Practical Development Workflow

To start working on a project within the container, follow these steps:

1. **Make Entrypoint Executable**:
   ```sh
   chmod +x entrypoint.sh
   ```
   This ensures that the entrypoint script has the necessary permissions to execute properly when the container starts.

2. **Access the ESP-IDF Container**:
   ```sh
   docker exec -it esp-idf-container /bin/bash
   ```
   This command opens an interactive shell in the container, allowing you to interact with the ESP-IDF tools and environment.

3. **Initialize ESP-IDF Environment**:
   ```sh
   get_idf
   ```
   Run the `get_idf` command to source the ESP-IDF environment setup script. This command prepares all necessary environment variables for development.

4. **Create a New Project**:
   ```sh
   idf.py create-project firmware
   ```
   This creates a new ESP-IDF project named `firmware` in the current working directory. The project will include all necessary files and structure to begin developing for ESP32.

5. **Change Directory and Adjust Permissions**:
   ```sh
   cd firmware
   sudo chown -R $USER:$USER /home/luist/esp_secureRF/firmware
   ```
   Move into the newly created project directory. Adjust permissions to ensure that the current user has the correct ownership over the project files, which may be necessary if they were created by a different user or within a container.

6. **Set Target for ESP-IDF**:
   ```sh
   idf.py set-target esp32
   ```
   Set the target to `esp32` to specify the microcontroller you are working with. This step ensures that all configurations and tools are aligned with the selected target.

### Command Guide Summary

Here is a summary of key commands used in the development process:

1. **Make Entrypoint Executable**:
   - `chmod +x entrypoint.sh`: Grants execute permissions to the entrypoint script to ensure it runs correctly.

2. **Access the ESP-IDF Container**:
   - `docker exec -it esp-idf-container /bin/bash`: Opens an interactive shell session inside the container.

3. **Initialize ESP-IDF Environment**:
   - `get_idf`: Sources the ESP-IDF environment to configure the necessary variables and tools.

4. **Create a New ESP-IDF Project**:
   - `idf.py create-project firmware`: Creates a new ESP-IDF project named `firmware` in the current working directory.

5. **Change to Project Directory and Fix Permissions**:
   - `cd firmware`: Changes to the newly created project directory.
   - `sudo chown -R $USER:$USER /home/luist/esp_secureRF/firmware`: Changes the ownership of the project files to the current user to prevent permission issues.

6. **Set Target for Development**:
   - `idf.py set-target esp32`: Sets the target microcontroller to `esp32`, ensuring the correct tools and configurations are used for development.

### Notes

- The `volumes` section allows preserving the ESP-IDF tools across different container sessions, reducing setup time.
- Environment variables are configured to simplify the ESP-IDF environment setup.
- The commands in this guide help ensure a smooth workflow when developing firmware for ESP32 devices.

This setup simplifies starting an ESP-IDF environment and managing project creation, configuration, and development tasks in a containerized setup, making the development process efficient and reproducible.