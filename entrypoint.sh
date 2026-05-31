#!/bin/sh
set -e

# Simple entrypoint that waits for the database to be reachable and runs
# initialization scripts once (via `scripts/ensure_db.py`) before starting
# the FastAPI server with uvicorn.

RETRIES=12
SLEEP=5

attempt=1
while [ $attempt -le $RETRIES ]
do
  echo "[entrypoint] Checking database (attempt $attempt/$RETRIES)..."
  if python /app/scripts/ensure_db.py; then
    echo "[entrypoint] Database ready/initialized."
    break
  fi
  attempt=$((attempt+1))
  echo "[entrypoint] Database not ready; sleeping ${SLEEP}s..."
  sleep $SLEEP
done

if [ $attempt -gt $RETRIES ]; then
  echo "[entrypoint] Database not ready after $RETRIES attempts. Exiting."
  exit 1
fi

# Exec the app process (replaces shell). Uvicorn is installed in user local bin.
echo "[entrypoint] Starting uvicorn..."
exec uvicorn main:app --host 0.0.0.0 --port 8000
