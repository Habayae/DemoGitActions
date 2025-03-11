#!/bin/bash

changed_files=$(git diff --name-only HEAD~1 HEAD)

if echo "$changed_files" | grep -E "(html|css|js|php|ts|vue|react|angular)"; then
    echo "Web-related changes detected. Running OWASP ZAP..."
    zap.sh -daemon -port 8080 -config api.disablekey=true
    sleep 10
    zap-cli quick-scan --url http://localhost:8080
    zap-cli report -o reports/zap-report.html -f html
else
    echo "Non-web changes detected. Running Veracode..."
    veracode scan --source . --output reports/veracode-dast.json
fi

if [ $? -ne 0 ]; then
    echo "DAST scan failed."
    exit 1
else
    echo "DAST scan passed successfully."
fi
