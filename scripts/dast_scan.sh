#!/bin/bash

echo "Starting OWASP ZAP daemon..."
zap.sh -daemon -port 8080 -config api.disablekey=true
sleep 10 

echo "Running DAST scan..."
zap-cli quick-scan --url http://localhost:8080

if [ $? -ne 0 ]; then
  echo "DAST scan failed."
  exit 1
else
  echo "DAST scan passed successfully."
fi
