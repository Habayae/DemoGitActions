#!/bin/bash

echo "Running DAST scan for application..."

zap-cli quick-scan --url http://localhost:8080

if [ $? -ne 0 ]; then
  echo "DAST scan failed, vulnerabilities detected."
  exit 1
else
  echo "DAST scan passed successfully."
fi
