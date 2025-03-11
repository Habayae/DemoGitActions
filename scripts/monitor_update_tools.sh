#!/bin/bash

echo "Checking and updating security tools..."

echo "Updating Dependency-Check..."
cd /path/to/dependency-check
git pull origin master

echo "Updating SonarQube..."
cd /path/to/sonar-scanner
git pull origin master

echo "Updating OWASP ZAP..."
cd /path/to/zap
git pull origin master


echo "Security tools have been updated."
