#!/bin/bash

echo "Running SCA scan for dependencies..."
mkdir -p reports
dependency-check --scan ./ --format HTML --out reports/dependency-check-report.html --project "MyProject"

if [ $? -ne 0 ]; then
  echo "SCA scan failed."
  exit 1
else
  echo "SCA scan passed successfully."
fi
