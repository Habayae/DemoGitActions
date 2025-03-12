#!/bin/bash

echo "Checking and updating security tools..."

echo "Updating OWASP ZAP..."
wget -O zap.zip https://github.com/zaproxy/zaproxy/releases/latest/download/ZAP_2_11_1_Linux.tar.gz
tar -xvzf zap.zip -C /opt/zap

echo "Security tools have been updated."
