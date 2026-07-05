#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PORT="${1:-8090}"
echo "Sunucu başlıyor: http://localhost:${PORT}"
python3 -m http.server "$PORT"
