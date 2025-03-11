#!/bin/bash

echo "Integrating security into the DevSecOps pipeline..."

echo "Running SCA (Static Code Analysis) to identify vulnerabilities..."
./github/scripts/sca_scan.sh

echo "Running SAST (Static Application Security Testing) to identify vulnerabilities..."
./github/scripts/sast_scan.sh

echo "Running DAST (Dynamic Application Security Testing) to identify vulnerabilities..."
./github/scripts/dast_scan.sh

echo "Running IAST (Interactive Application Security Testing) to identify vulnerabilities..."
./github/scripts/iast_scan.sh 

echo "Evaluating risk based on scan reports..."
./github/scripts/evaluate_risk.sh

echo "Prioritizing vulnerabilities for remediation..."
./github/scripts/prioritize_vulnerabilities.sh

echo "Improving and optimizing code based on identified vulnerabilities..."
./github/scripts/improve_code.sh

echo "Security has been integrated into the DevSecOps pipeline."
