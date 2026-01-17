#!/bin/sh
set -e

# Replace environment variables in datasources.yml (temp file: portable, works as user grafana)
if [ -f /etc/grafana/provisioning/datasources/datasources.yml ]; then
  sed "s|\$LOKI_INTERNAL_URL|${LOKI_INTERNAL_URL:-http://loki.railway.internal:3100}|g" /etc/grafana/provisioning/datasources/datasources.yml | \
  sed "s|\$PROMETHEUS_INTERNAL_URL|${PROMETHEUS_INTERNAL_URL:-http://prometheus.railway.internal:9090}|g" | \
  sed "s|\$TEMPO_INTERNAL_URL|${TEMPO_INTERNAL_URL:-http://tempo.railway.internal:3200}|g" > /tmp/datasources.yml && \
  mv /tmp/datasources.yml /etc/grafana/provisioning/datasources/datasources.yml
fi

# Execute the original Grafana entrypoint
exec /run.sh "$@"
