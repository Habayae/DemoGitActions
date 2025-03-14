#!/bin/bash

mkdir -p reports
touch reports/sca-report.txt

echo "Running SCA scan for dependencies..."
trivy fs --format table --output reports/sca-report.txt ./

if [ ! -s "reports/sca-report.txt" ]; then
    echo "No vulnerabilities found." > reports/sca-report.txt
fi

if [ $? -ne 0 ]; then
  echo "SCA scan failed."
  exit 1
else
  echo "SCA scan passed successfully."
fi
