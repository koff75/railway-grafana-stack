#!/bin/sh
set -e

# Provisioning in /tmp (writable by user grafana, no root/chown needed)
# Grafana reads from GF_PATHS_PROVISIONING; we never write to /etc/grafana
mkdir -p /tmp/provisioning/datasources /tmp/provisioning/dashboards

# Substitute env vars into datasources.yml
if [ -f /etc/grafana/provisioning/datasources/datasources.yml ]; then
  sed "s|\$LOKI_INTERNAL_URL|${LOKI_INTERNAL_URL:-http://loki.railway.internal:3100}|g" /etc/grafana/provisioning/datasources/datasources.yml | \
  sed "s|\$PROMETHEUS_INTERNAL_URL|${PROMETHEUS_INTERNAL_URL:-http://prometheus.railway.internal:9090}|g" | \
  sed "s|\$TEMPO_INTERNAL_URL|${TEMPO_INTERNAL_URL:-http://tempo.railway.internal:3200}|g" > /tmp/provisioning/datasources/datasources.yml
fi

# Copy dashboards (path in dashboards.yml points to /etc/... which we keep readable)
cp -r /etc/grafana/provisioning/dashboards/* /tmp/provisioning/dashboards/ 2>/dev/null || true

export GF_PATHS_PROVISIONING=/tmp/provisioning
exec /run.sh "$@"
