#!/usr/bin/env bash
# Restore the mydb.dump into the Render PostgreSQL database.
# Usage: DATABASE_URL=<render-external-db-url> ./bin/db-restore.sh
#
# You can find the External Database URL in Render dashboard -> your DB -> Info.
# Run this once after creating the service, before (or instead of) db:migrate.
set -o errexit

DUMP_FILE="$(dirname "$0")/../mydb.dump"

if [ -z "$DATABASE_URL" ]; then
  echo "ERROR: DATABASE_URL is not set."
  echo "Export the Render external database URL first:"
  echo "  export DATABASE_URL=<your-render-external-db-url>"
  exit 1
fi

echo "Restoring $DUMP_FILE into \$DATABASE_URL ..."
pg_restore --verbose --clean --no-acl --no-owner -d "$DATABASE_URL" "$DUMP_FILE"
echo "Done."
