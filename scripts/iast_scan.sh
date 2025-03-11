#!/bin/bash

echo "Running IAST scan using OWASP ZAP..."

zap.sh -daemon -port 8080 -config api.disablekey=true

sleep 10

zap-cli quick-scan --url http://localhost:8080

sleep 10

zap-cli report -o zap_report.html -f html

if [ $? -ne 0 ]; then
  echo "IAST scan failed, vulnerabilities detected."
  exit 1
else
  echo "IAST scan passed successfully."
fi
