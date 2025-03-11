#!/bin/bash

echo "Running SCA scan for dependencies..."
mkdir -p reports
trivy fs --format table --output reports/sca-report.txt ./

if [ $? -ne 0 ]; then
  echo "SCA scan failed."
  exit 1
else
  echo "SCA scan passed successfully."
fi
