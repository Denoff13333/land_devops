#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="${1}"           # e.g. land_devops
VER="${2}"                 # e.g. 0.17.24
PR_NUMBER="${3}"           # e.g. 148
DOCKERHUB_REPO="${4}"      # e.g. denoff1337/land_devops

BOT_TOKEN="${TELEGRAM_BOT_TOKEN}"
CHAT_ID="${TELEGRAM_CHAT_ID}"

REPO_FULL="${GITHUB_REPOSITORY}"            # e.g. Den0ff13333/land_devops
OWNER="${REPO_FULL%%/*}"                    # e.g. Den0ff13333
AUTHOR="${GITHUB_ACTOR:-unknown}"
DATE_UTC="$(date -u +'%Y.%m.%d  %H:%M:%S')"
GIT_TAG="v${VER}"

PR_LINK="https://github.com/${REPO_FULL}/pull/${PR_NUMBER}"
TAG_LINK="https://github.com/${REPO_FULL}/releases/tag/${GIT_TAG}"
REPO_LINK="https://github.com/${REPO_FULL}"
DH_REPO_LINK="https://hub.docker.com/r/${DOCKERHUB_REPO}"
IMAGE_FULL="${DOCKERHUB_REPO}:${GIT_TAG}"

read -r -d '' MSG <<EOF
<b>Новый выпуск изменений</b>
<b>Проект</b> : <a href="${REPO_LINK}">${REPO_NAME}</a>
<b>Версия</b> : <code>${VER}</code>
<b>Дата</b>: <code>${DATE_UTC}</code>
<b>Автор</b>: ${AUTHOR}

<b>Информация о Git-репозитории</b>
<b>GIT MR</b> : <a href="${PR_LINK}">${PR_NUMBER}</a>
<b>GIT TAG</b>: <a href="${TAG_LINK}">${GIT_TAG}</a>

<b>Информация о Docker-репозитории</b>
<b>Владелец</b>: ${OWNER}
<b>Название</b>: ${REPO_NAME}
<b>Тег</b>: <code>${GIT_TAG}</code>
<b>Полное имя</b>: <a href="${DH_REPO_LINK}">${IMAGE_FULL}</a>
EOF

curl -sS "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d chat_id="${CHAT_ID}" \
  -d parse_mode="HTML" \
  --data-urlencode text="${MSG}" >/dev/null

if [ -f CHANGELOG.md ]; then
  curl -sS -F chat_id="${CHAT_ID}" \
    -F document="@CHANGELOG.md;filename=changelog.md" \
    "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" >/dev/null
fi

echo "Telegram notification sent."
