#!/usr/bin/env bash
set -euo pipefail

BOT="$TELEGRAM_BOT_TOKEN"
CHAT="$TELEGRAM_CHAT_ID"

PROJECT="${1}"
VERSION="${2}"
PR="${3}"
DOCKER_REPO="${4}"
TAG="v${VERSION}"

TEXT="*Новый выпуск изменений*\n\n\
*Проект:* ${PROJECT}\n\
*Версия:* ${VERSION}\n\
*Дата:* $(date '+%Y.%m.%d %H:%M:%S')\n\
*Автор:* $(git log -1 --pretty=format:'%an')\n\n\
*Информация о Git-репозитории*\n\
GIT MR: [${PR}](https://github.com/${GITHUB_REPOSITORY}/pull/${PR})\n\
GIT TAG: [${TAG}](https://github.com/${GITHUB_REPOSITORY}/releases/tag/${TAG})\n\n\
*Информация о Docker-репозитории*\n\
Владелец: ${DOCKER_REPO%%/*}\n\
Название: ${PROJECT}\n\
Тег: ${TAG}\n\
Полное имя: [${DOCKER_REPO}:${TAG}](https://hub.docker.com/r/${DOCKER_REPO})"


curl -sS "https://api.telegram.org/bot${BOT}/sendMessage" \
  -d chat_id="${CHAT}" \
  -d parse_mode=MarkdownV2 \
  --data-urlencode "text=${TEXT}" >/dev/null


curl -sS -F chat_id="${CHAT}" -F document="@CHANGELOG.md" \
  "https://api.telegram.org/bot${BOT}/sendDocument" >/dev/null
