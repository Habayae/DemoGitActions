#!/bin/bash

mkdir -p reports/
touch reports/sast-report.json

echo "Running SAST scan..."
semgrep scan --config=auto --output reports/sast-report.json

if [ $? -ne 0 ]; then
  echo "SAST scan failed."
  exit 1
else
  echo "SAST scan passed successfully."
fi
