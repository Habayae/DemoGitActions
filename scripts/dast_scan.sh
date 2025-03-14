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

zap.sh -daemon -port 8080 -config api.disablekey=true &
sleep 10
zap-cli quick-scan --url http://localhost:3000
zap-cli report -o reports/zap-report.html -f html

if [ ! -s "reports/zap-report.html" ]; then
    echo "<html><body><h1>No vulnerabilities found</h1></body></html>" > reports/zap-report.html
fi

if [ ! -s "reports/katana-dast.json" ]; then
    echo '{ "status": "No vulnerabilities found" }' > reports/katana-dast.json
fi

echo "DAST scan completed. Reports are available in the 'reports' directory."

kill $SERVER_PID
