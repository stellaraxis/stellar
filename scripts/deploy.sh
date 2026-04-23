#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

NGINX_CONF_PATH="${NGINX_CONF_PATH:-/etc/nginx/nginx.conf}"
LOG_DIR="${LOG_DIR:-${REPO_ROOT}/logs}"
LOG_FILE="${LOG_FILE:-${LOG_DIR}/deploy.log}"

mkdir -p "${LOG_DIR}"

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "${LOG_FILE}"
}

require_command() {
  local command_name="$1"
  if ! command -v "${command_name}" >/dev/null 2>&1; then
    log "未检测到命令 ${command_name}，部署终止。"
    exit 1
  fi
}

cd "${REPO_ROOT}"

require_command npm
require_command sudo
require_command nginx

if [[ ! -f "${REPO_ROOT}/nginx.conf" ]]; then
  log "未找到 ${REPO_ROOT}/nginx.conf，部署终止。"
  exit 1
fi

if [[ -f package-lock.json ]]; then
  log "检测到 package-lock.json，开始执行 npm ci。"
  npm ci >> "${LOG_FILE}" 2>&1
else
  log "未检测到 package-lock.json，开始执行 npm install。"
  npm install >> "${LOG_FILE}" 2>&1
fi

log "开始覆盖 ${NGINX_CONF_PATH}。"
sudo cp "${REPO_ROOT}/nginx.conf" "${NGINX_CONF_PATH}" >> "${LOG_FILE}" 2>&1

log "开始重载 Nginx。"
sudo nginx -s reload >> "${LOG_FILE}" 2>&1

log "开始重新构建当前站点。"
npm run docs:build >> "${LOG_FILE}" 2>&1

log "部署完成。"
