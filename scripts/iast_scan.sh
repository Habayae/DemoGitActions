#!/bin/bash

echo "Running IAST scan..."
zap.sh -daemon -port 8080 -config api.disablekey=true
sleep 10
zap-cli quick-scan --url http://localhost:8080
sleep 10
zap-cli report -o reports/zap-report.html -f html

echo "Running AppScan IAST..."
appscan start-monitoring &
node app.js  
sleep 30
appscan stop-monitoring --output reports/iast-report.json

if [ $? -ne 0 ]; then
  echo "IAST scan failed."
  exit 1
else
  echo "IAST scan passed successfully."
fi
