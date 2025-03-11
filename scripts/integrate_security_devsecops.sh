#!/bin/bash

echo "Integrating security into the DevSecOps pipeline..."

echo "Running SCA..."
./scripts/sca_scan.sh

echo "Running SAST..."
./scripts/sast_scan.sh

echo "Running DAST..."
./scripts/dast_scan.sh

echo "Running IAST..."
./scripts/iast_scan.sh 

echo "Evaluating risk..."
./scripts/evaluate_risk.sh

echo "Prioritizing vulnerabilities..."
./scripts/prioritize_vulnerabilities.sh

echo "Improving code..."
./scripts/improve_code.sh

echo "Security integration completed."
