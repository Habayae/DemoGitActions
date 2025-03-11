#!/bin/bash

echo "Running SAST scan for source code..."

sonar-scanner

if [ $? -ne 0 ]; then
  echo "SAST scan failed, vulnerabilities detected."
  exit 1
else
  echo "SAST scan passed successfully."
fi
