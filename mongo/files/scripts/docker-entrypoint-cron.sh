#!/bin/bash

echo "Executing cron in background."
cron -f &
echo "Executing docker-entrypoint.sh"
/usr/local/bin/docker-entrypoint.sh "$@"
