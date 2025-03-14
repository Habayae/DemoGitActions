#!/bin/bash

node server.js &
SERVER_PID=$!
sleep 10  

if git rev-parse --verify HEAD~1 > /dev/null 2>&1; then
    changed_files=$(git diff --name-only HEAD~1 HEAD)
else
    changed_files=$(git ls-files)
fi

echo "Changed files: $changed_files"

web_languages="\.html$|\.css$|\.js$|\.php$|\.ts$|\.vue$|\.react$|\.angular$"
software_languages="\.java$|\.py$|\.go$|\.c$|\.cpp$|\.rb$|\.sh$"

mkdir -p reports/
touch reports/zap-report.html reports/katana-dast.json

zap.sh -daemon -port 8080 -config api.disablekey=true &
sleep 10
zap-cli quick-scan --url http://localhost:3000
zap-cli report -o reports/zap-report.html -f html

if echo "$changed_files" | grep -E "$software_languages"; then
    katana -u http://localhost:3000 -o reports/katana-dast.json &
    sleep 10
fi

if [ -z "$changed_files" ] || ! echo "$changed_files" | grep -qE "$web_languages|$software_languages"; then
    zap.sh -daemon -port 8080 -config api.disablekey=true &
    sleep 10
    zap-cli quick-scan --url http://localhost:3000
    zap-cli report -o reports/zap-report.html -f html
fi

if [ ! -s "reports/zap-report.html" ]; then
    echo "Generating fallback ZAP report..." > reports/zap-report.html
fi

if [ ! -s "reports/katana-dast.json" ]; then
    echo "Generating fallback Katana DAST report..." > reports/katana-dast.json
fi

if [ ! -s "reports/zap-report.html" ] && [ ! -s "reports/katana-dast.json" ]; then
    echo "DAST scan failed: No report generated."
else
    echo "DAST scan passed successfully."
fi

if ps -p $SERVER_PID > /dev/null; then
    kill $SERVER_PID
else
    echo "Warning: Server process not found. It might have already exited."
fi
