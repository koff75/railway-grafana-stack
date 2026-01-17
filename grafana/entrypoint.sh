#!/bin/sh
set -e

# Replace environment variables in datasources.yml
if [ -f /etc/grafana/provisioning/datasources/datasources.yml ]; then
  sed -i "s|\$LOKI_INTERNAL_URL|${LOKI_INTERNAL_URL:-http://loki.railway.internal:3100}|g" /etc/grafana/provisioning/datasources/datasources.yml
  sed -i "s|\$PROMETHEUS_INTERNAL_URL|${PROMETHEUS_INTERNAL_URL:-http://prometheus.railway.internal:9090}|g" /etc/grafana/provisioning/datasources/datasources.yml
  sed -i "s|\$TEMPO_INTERNAL_URL|${TEMPO_INTERNAL_URL:-http://tempo.railway.internal:3200}|g" /etc/grafana/provisioning/datasources/datasources.yml
fi

# Execute the original Grafana entrypoint
exec /run.sh "$@"
