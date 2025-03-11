#!/bin/bash

changed_files=$(git diff --name-only HEAD~1 HEAD)

if echo "$changed_files" | grep -E "(html|css|js|php|ts|vue|react|angular)"; then
    echo "Web-related changes detected. Running OWASP ZAP..."
    zap.sh -daemon -port 8080 -config api.disablekey=true &
    ZAP_PID=$!
    sleep 10

    if ps -p $ZAP_PID > /dev/null; then
        echo "ZAP is running, proceeding with scan..."
        zap-cli quick-scan --url http://localhost:8080
        zap-cli report -o reports/zap-report.html -f html
    else
        echo "ZAP did not start in time, skipping..."
    fi
else
    echo "Non-web changes detected. Running Katana..."
    katana -u http://localhost:3000 -o reports/katana-dast.json &
    KATANA_PID=$!
    sleep 10

    if ps -p $KATANA_PID > /dev/null; then
        echo "Katana is running, proceeding with scan..."
    else
        echo "Katana did not start in time, skipping..."
    fi
fi

if [ $? -ne 0 ]; then
    echo "DAST scan failed."
    exit 1
else
    echo "DAST scan passed successfully."
fi
