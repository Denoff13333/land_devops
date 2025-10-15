#!/usr/bin/env bash
set -euo pipefail

BOT="$TELEGRAM_BOT_TOKEN"
CHAT="$TELEGRAM_CHAT_ID"

PROJECT="${1}"
VERSION="${2}"
PR="${3}"
DOCKER_REPO="${4}"
TAG="v${VERSION}"


TEXT=$(cat <<EOF
<b>Новый выпуск изменений</b>

<b>Проект:</b> ${PROJECT}
<b>Версия:</b> ${VERSION}
<b>Дата:</b> $(date '+%Y.%m.%d %H:%M:%S')

<b>Информация о Git</b>
MR: <a href="https://github.com/${GITHUB_REPOSITORY}/pull/${PR}">#${PR}</a>
Tag: <a href="https://github.com/${GITHUB_REPOSITORY}/releases/tag/${TAG}">${TAG}</a>

<b>Информация о Docker</b>
Репозиторий: <a href="https://hub.docker.com/r/${DOCKER_REPO}">${DOCKER_REPO}</a>
Тег: <code>${TAG}</code>
Полное имя: <code>${DOCKER_REPO}:${TAG}</code>
EOF
)


curl -fsS -X POST "https://api.telegram.org/bot${BOT}/sendMessage" \
  -d chat_id="${CHAT}" \
  -d parse_mode=HTML \
  --data-urlencode "text=${TEXT}"


curl -fsS -X POST "https://api.telegram.org/bot${BOT}/sendDocument" \
  -F chat_id="${CHAT}" \
  -F document="@CHANGELOG.md"
