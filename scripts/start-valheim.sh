#!/usr/bin/env bash
set -euo pipefail

export SteamAppId=892970
export LD_LIBRARY_PATH="$PWD/linux64:${LD_LIBRARY_PATH:-}"

exec ./valheim_server.x86_64 \
  -nographics \
  -batchmode \
  -name "$SERVER_NAME" \
  -port "$SERVER_PORT" \
  -world "$WORLD_NAME" \
  -password "$SERVER_PASSWORD" \
  -public "$SERVER_PUBLIC" \
  -savedir "$SAVE_DIR"
