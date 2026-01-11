#!/bin/sh
set -e

# Set default values if not provided
export PROXY_PORT="${PROXY_PORT:-3128}"
export RESOLVER_IP="${RESOLVER_IP:-1.1.1.1}"
export RESOLVER_IPV6="${RESOLVER_IPV6:-off}"
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
  envsubst '${PROXY_PORT} ${RESOLVER_IP} ${RESOLVER_IPV6}' < "$TEMPLATE_FILE" > "$CONFIG_FILE"
fi

# Test the configuration
nginx -t

# Execute the CMD from Dockerfile (passed as arguments to this script)
exec "$@"
