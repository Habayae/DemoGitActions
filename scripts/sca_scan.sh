#!/bin/bash

echo "Running SCA scan for dependencies..."

snyk test --all-projects

if [ $? -ne 0 ]; then
  echo "SCA scan failed, vulnerabilities detected."
  exit 1
else
  echo "SCA scan passed successfully."
fi
