#!/bin/bash
set -e

# Wait for database to be ready
until pg_isready -h db -p 5432 -U postgres; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

# If database exists, migrate. Otherwise setup (create and migrate)
bundle exec rails db:prepare

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@" 