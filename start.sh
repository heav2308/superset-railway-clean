#!/bin/sh
set -eu

export FLASK_APP=superset
export SUPERSET_CONFIG_PATH="${SUPERSET_CONFIG_PATH:-/app/superset_config.py}"
export PORT="${PORT:-8088}"

/app/.venv/bin/python -c "import psycopg2; print('psycopg2 OK')"

n=0
until /app/.venv/bin/superset db upgrade; do
  n=$((n+1))
  if [ "$n" -ge 20 ]; then
    echo "Metadata DB not ready after retries"
    exit 1
  fi
  sleep 3
done

/app/.venv/bin/superset fab create-admin \
  --username "${ADMIN_USERNAME}" \
  --firstname "Admin" \
  --lastname "User" \
  --email "${ADMIN_EMAIL}" \
  --password "${ADMIN_PASSWORD}" || true

/app/.venv/bin/superset init

exec /app/.venv/bin/superset run -p "${PORT}" --host 0.0.0.0 --with-threads
