#!/bin/bash
set -e

# Load modules
source /scripts/env.sh
source /scripts/utils.sh

log_info "=== BattleBit Docker Container ==="

# Ensure directories exist
mkdir -p "$BATTLEBIT_HOME"

# Start the server
source /scripts/start.sh
start_server "$@"
