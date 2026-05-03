#!/usr/bin/env bash
set -euo pipefail

STAGECTL_PATH="${STAGECTL:-./bin/stagectl}"
DOWNLOAD_URL="${STAGECTL_DOWNLOAD_URL:-}"

# Preferred path: use repository-bundled binary when the file exists.
if [[ -f "${STAGECTL_PATH}" ]]; then
  chmod +x "${STAGECTL_PATH}" || true
  if [[ -x "${STAGECTL_PATH}" ]]; then
    echo "Using bundled stagectl binary at ${STAGECTL_PATH}"
    "${STAGECTL_PATH}" version
    exit 0
  fi
  echo "stagectl binary exists at ${STAGECTL_PATH} but is still not executable after chmod +x." >&2
  exit 1
fi

# Fallback path: download a release artifact when explicitly configured.
if [[ -n "${DOWNLOAD_URL}" ]]; then
  mkdir -p "$(dirname "${STAGECTL_PATH}")"
  curl -fsSL "${DOWNLOAD_URL}" -o "${STAGECTL_PATH}"
  chmod +x "${STAGECTL_PATH}"
  echo "Downloaded stagectl to ${STAGECTL_PATH}"
  "${STAGECTL_PATH}" version
  exit 0
fi

echo "stagectl binary not found at ${STAGECTL_PATH} and STAGECTL_DOWNLOAD_URL is not set." >&2
echo "Provide a repository variable or workflow input with a downloadable release asset URL." >&2
exit 1
