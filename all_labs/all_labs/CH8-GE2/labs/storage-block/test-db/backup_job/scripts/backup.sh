#!/bin/bash

set -x

POSTGRES_POD="postgresql-0"

oc exec "$POSTGRES_POD" -- psql < /mnt/scripts/start_backup.sql

oc exec "$POSTGRES_POD" -- tar czf - -C /var/lib/pgsql/data userdata > /mnt/backup/backup.tar.gz

oc exec "$POSTGRES_POD" -- psql < /mnt/scripts/stop_backup.sql
