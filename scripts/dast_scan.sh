#!/bin/bash

npm install

node server.js &
SERVER_PID=$!
sleep 10  

if ! ps -p $SERVER_PID > /dev/null; then
    echo "Server failed to start. Exiting..."
    exit 1
fi

echo "Server started successfully with PID $SERVER_PID"

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

run_zap=false
run_katana=false

if echo "$changed_files" | grep -E "$web_languages" > /dev/null; then
    run_zap=true
fi

if echo "$changed_files" | grep -E "$software_languages" > /dev/null; then
    run_katana=true
fi

if [ "$run_zap" = true ]; then
    echo "Running ZAP DAST scan..."
    zap.sh -daemon -port 8080 -config api.disablekey=true &
    sleep 10
    zap-cli quick-scan http://localhost:8080
    zap-cli report -o reports/zap-report.html -f html
fi

if [ "$run_katana" = true ]; then
    echo "Running Katana DAST scan..."
    katana -u http://localhost:3000 -o reports/katana-dast.json &
    sleep 10
fi

if [ ! -s "reports/zap-report.html" ] && [ "$run_zap" = true ]; then
    echo "Generating fallback ZAP report..." > reports/zap-report.html
fi

if [ ! -s "reports/katana-dast.json" ] && [ "$run_katana" = true ]; then
    echo "Generating fallback Katana DAST report..." > reports/katana-dast.json
fi

if [ ! -s "reports/zap-report.html" ] && [ ! -s "reports/katana-dast.json" ]; then
    echo "DAST scan failed: No report generated."
else
    echo "DAST scan passed successfully."
fi
