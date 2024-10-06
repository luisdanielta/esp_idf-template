#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Source the ESP-IDF environment
# Check if the export script exists, then source it to set up the environment
if [ -f /opt/esp/idf/export.sh ]; then
    . /opt/esp/idf/export.sh
else
    # Print an error message and exit if the script is not found
    echo "Error: export.sh script not found at /opt/esp/idf/export.sh"
    exit 1
fi

# Execute the command passed to the container
# Use exec to replace the shell with the specified command, allowing proper signal handling
exec "$@"