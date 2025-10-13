#!/usr/bin/env bash
set -euo pipefail
BOT="$TELEGRAM_BOT_TOKEN"
CHAT="$TELEGRAM_CHAT_ID"

PROJECT="${1}"
VERSION="${2}"
PR="${3}"
DOCKER_REPO="${4}"
TAG="v${VERSION}"

TEXT="*Новый выпуск изменений*\n\n*Проект:* ${PROJECT}\n*Версия:* ${VERSION}\n*GIT PR:* ${PR}\n*GIT TAG:* ${TAG}\n\n*Docker:* \`${DOCKER_REPO}:${TAG}\`"

curl -sS "https://api.telegram.org/bot${BOT}/sendMessage" \
  -d chat_id="${CHAT}" \
  -d parse_mode=Markdown \
  --data-urlencode "text=${TEXT}" >/dev/null

curl -sS -F chat_id="${CHAT}" -F document="@CHANGELOG.md" \
  "https://api.telegram.org/bot${BOT}/sendDocument" >/dev/null
