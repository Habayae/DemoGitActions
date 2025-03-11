#!/bin/bash

echo "Checking and updating security tools..."

echo "Updating Dependency-Check..."
wget -O dependency-check.zip https://github.com/jeremylong/DependencyCheck/releases/latest/download/dependency-check.zip
unzip -o dependency-check.zip -d /opt/dependency-check

echo "Updating SonarQube..."
wget -O sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip
unzip -o sonar-scanner.zip -d /opt/sonar-scanner

echo "Updating OWASP ZAP..."
wget -O zap.zip https://github.com/zaproxy/zaproxy/releases/latest/download/ZAP_2_11_1_Linux.tar.gz
tar -xvzf zap.zip -C /opt/zap

echo "Security tools have been updated."
