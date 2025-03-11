#!/bin/bash

echo "Running SAST scan..."
sonar-scanner

if [ $? -ne 0 ]; then
  echo "SAST scan failed."
  exit 1
else
  echo "SAST scan passed successfully."
fi
