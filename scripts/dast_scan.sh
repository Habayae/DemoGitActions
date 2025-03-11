#!/bin/bash

node server.js &
SERVER_PID=$!
sleep 10  

if git rev-parse HEAD~1 >/dev/null 2>&1; then
    changed_files=$(git diff --name-only HEAD~1 HEAD)
else
    changed_files=""
fi

mkdir -p reports/
touch reports/zap-report.html reports/katana-dast.json

if echo "$changed_files" | grep -E "(html|css|js|php|ts|vue|react|angular)"; then
    echo "Web-related changes detected. Running OWASP ZAP..."
    zap.sh -daemon -port 8080 -config api.disablekey=true &
    sleep 10
    zap-cli quick-scan --url http://localhost:3000
    zap-cli report -o reports/zap-report.html -f html
else
    echo "Non-web changes detected. Running Katana..."
    katana -u http://localhost:3000 -o reports/katana-dast.json &
    sleep 10
fi

if [ ! -s "reports/zap-report.html" ] && [ ! -s "reports/katana-dast.json" ]; then
    echo "DAST scan failed: No report generated."
    exit 1
else
    echo "DAST scan passed successfully."
fi

kill $SERVER_PID
