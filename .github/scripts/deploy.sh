#!/usr/bin/env bash
set -euo pipefail

IMAGE="$1"          # <repo>:vX.Y.Z
CONTAINER_NAME="land-app"

docker rm -f "${CONTAINER_NAME}" 2>/dev/null || true
docker pull "${IMAGE}"
docker run -d --name "${CONTAINER_NAME}" -p 8080:80 "${IMAGE}"

echo "App is up at http://localhost:8080"
