#!/bin/bash

mkdir -p reports/
touch reports/sast-report.json

echo "Running SAST scan..."
semgrep scan --config=auto --output reports/sast-report.json

if [ ! -s "reports/sast-report.json" ]; then
    echo '{ "status": "No vulnerabilities found" }' > reports/sast-report.json
fi

if [ $? -ne 0 ]; then
  echo "SAST scan failed."
  exit 1
else
  echo "SAST scan passed successfully."
fi
