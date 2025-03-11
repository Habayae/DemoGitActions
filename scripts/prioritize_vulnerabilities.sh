#!/bin/bash

echo "Prioritizing vulnerabilities based on risk levels..."

risk_report="./risk-evaluation-report.txt"

if [ ! -f "$risk_report" ]; then
  echo "Risk evaluation report not found!"
  exit 1
fi

priority_report="./vulnerability-priority-report.txt"

if [ -f "$priority_report" ]; then
  rm "$priority_report"
fi

echo "Creating vulnerability priority report..." > "$priority_report"
echo "======================================" >> "$priority_report"

critical_vulnerabilities=$(grep "Critical" "$risk_report" | wc -l)
high_vulnerabilities=$(grep "High" "$risk_report" | wc -l)
medium_vulnerabilities=$(grep "Medium" "$risk_report" | wc -l)
low_vulnerabilities=$(grep "Low" "$risk_report" | wc -l)

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
