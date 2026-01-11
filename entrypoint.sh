#!/bin/sh
set -e

# Set default values if not provided
export PROXY_PORT="${PROXY_PORT:-3128}"
export WORKER_PROCESSES="${WORKER_PROCESSES:-auto}"
export WORKER_CONNECTIONS="${WORKER_CONNECTIONS:-1024}"
export RESOLVER="${RESOLVER:-1.1.1.1}"
export RESOLVER_TIMEOUT="${RESOLVER_TIMEOUT:-5s}"
export PROXY_CONNECT_TIMEOUT="${PROXY_CONNECT_TIMEOUT:-60s}"
export PROXY_SEND_TIMEOUT="${PROXY_SEND_TIMEOUT:-60s}"
export PROXY_READ_TIMEOUT="${PROXY_READ_TIMEOUT:-60s}"
export SEND_TIMEOUT="${SEND_TIMEOUT:-60s}"
export CLIENT_BODY_TIMEOUT="${CLIENT_BODY_TIMEOUT:-60s}"
export CLIENT_HEADER_TIMEOUT="${CLIENT_HEADER_TIMEOUT:-60s}"
export KEEPALIVE_TIMEOUT="${KEEPALIVE_TIMEOUT:-65s}"
export FORCE_CONFIG_GENERATION="${FORCE_CONFIG_GENERATION:-false}"

CONFIG_FILE="/usr/local/nginx/conf/nginx.conf"
TEMPLATE_FILE="/usr/local/nginx/conf/nginx.conf.template"

# Check if nginx.conf already exists (e.g., from volume mount)
# Skip template generation unless FORCE_CONFIG_GENERATION is set to true
if [ -f "$CONFIG_FILE" ] && [ "$FORCE_CONFIG_GENERATION" != "true" ]; then
  echo "Found existing nginx.conf, skipping template generation"
  echo "Set FORCE_CONFIG_GENERATION=true to override"
else
  echo "Generating nginx.conf from template with environment variables"
  # Use envsubst with explicit variable list to avoid replacing nginx variables like $host
  envsubst '${PROXY_PORT} ${WORKER_PROCESSES} ${WORKER_CONNECTIONS} ${RESOLVER} ${RESOLVER_TIMEOUT} ${PROXY_CONNECT_TIMEOUT} ${PROXY_SEND_TIMEOUT} ${PROXY_READ_TIMEOUT} ${SEND_TIMEOUT} ${CLIENT_BODY_TIMEOUT} ${CLIENT_HEADER_TIMEOUT} ${KEEPALIVE_TIMEOUT}' < "$TEMPLATE_FILE" > "$CONFIG_FILE"
fi

# Test the configuration
nginx -t

# Execute the CMD from Dockerfile (passed as arguments to this script)
exec "$@"
