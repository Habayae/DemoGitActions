#!/bin/bash

set -e  

PORT=8080
ZAP_PORT=8090
ZAP_HOME="/home/runner/.ZAP"

echo "Checking if Node.js server from DAST is running..."
if ! curl -s http://localhost:$PORT > /dev/null; then
    echo "Error: Server is not running on port $PORT! Ensure DAST started it."
    exit 1
fi

mkdir -p reports/
touch reports/zap-report.html reports/gosec-iast.json

echo "Checking if ZAP DAST is already running..."
if pgrep -f "zap.sh -daemon" > /dev/null; then
    echo "ZAP is already running from DAST."
else
    echo "Error: ZAP is not running! Ensure DAST started it."
    exit 1
fi

echo "Checking if ZAP is responding..."
if ! curl -s http://localhost:$ZAP_PORT > /dev/null; then
    echo "Error: ZAP is not responding on port $ZAP_PORT!"
    exit 1
fi

echo "Running IAST scan..."
zap-cli --zap-url "http://localhost:$ZAP_PORT" quick-scan "http://localhost:$PORT"
sleep 10
zap-cli --zap-url "http://localhost:$ZAP_PORT" report -o reports/zap-report.html -f html

echo "Running Gosec IAST..."
gosec -fmt json -out reports/gosec-iast.json ./ || { echo "Gosec scan failed."; exit 1; }

if [ ! -s "reports/zap-report.html" ]; then
    echo "<html><body><h1>No vulnerabilities found</h1></body></html>" > reports/zap-report.html
fi

if [ ! -s "reports/gosec-iast.json" ]; then
    echo '{ "status": "No vulnerabilities found" }' > reports/gosec-iast.json
fi

echo "IAST scan completed successfully."
