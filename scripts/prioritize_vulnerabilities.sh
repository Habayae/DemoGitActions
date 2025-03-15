#!/bin/bash

echo "Prioritizing vulnerabilities based on risk levels..."

mkdir -p reports
risk_report="./reports/risk-evaluation-report.txt"
priority_report="./reports/vulnerability-priority-report.txt"

touch "$risk_report" "$priority_report"

if [ ! -s "$risk_report" ]; then
  echo "Risk evaluation report is empty or not found!" > "$priority_report"
  echo "No vulnerabilities detected." >> "$priority_report"
  echo "Vulnerability priority report saved to $priority_report"
  exit 0
fi

echo "Creating vulnerability priority report..." > "$priority_report"
echo "======================================" >> "$priority_report"

critical_vulnerabilities=$(grep -c "Critical" "$risk_report")
high_vulnerabilities=$(grep -c "High" "$risk_report")
medium_vulnerabilities=$(grep -c "Medium" "$risk_report")
low_vulnerabilities=$(grep -c "Low" "$risk_report")

echo "Critical vulnerabilities: $critical_vulnerabilities" >> "$priority_report"
echo "High vulnerabilities: $high_vulnerabilities" >> "$priority_report"
echo "Medium vulnerabilities: $medium_vulnerabilities" >> "$priority_report"
echo "Low vulnerabilities: $low_vulnerabilities" >> "$priority_report"

echo "======================================" >> "$priority_report"

if [ $critical_vulnerabilities -gt 0 ]; then
  echo "Priority: Critical vulnerabilities need immediate attention!" >> "$priority_report"
elif [ $high_vulnerabilities -gt 0 ]; then
  echo "Priority: High vulnerabilities should be addressed soon!" >> "$priority_report"
elif [ $medium_vulnerabilities -gt 0 ]; then
  echo "Priority: Medium vulnerabilities can be addressed later." >> "$priority_report"
else
  echo "Priority: Low vulnerabilities are low risk." >> "$priority_report"
fi

echo "Vulnerability priority report saved to $priority_report"
