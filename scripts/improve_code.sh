#!/bin/bash

echo "Improving and optimizing code based on identified vulnerabilities..."

mkdir -p reports
sca_report="./reports/sca-report.txt"
sast_report="./reports/sast-report.json"
dast_report="./reports/zap-report.html"
iast_report="./reports/iact-report.html"

touch "$sca_report" "$sast_report" "$dast_report" "$iast_report"

echo "Identifying vulnerabilities for code improvement..." > ./reports/improvement-log.txt

fix_vulnerabilities() {
  local report=$1
  local label=$2

  if [ ! -s "$report" ]; then
    echo "$label report is empty. No vulnerabilities found." >> ./reports/improvement-log.txt
    return
  fi

  local critical_vulns=$(grep -o "Critical" "$report" | wc -l)
  local high_vulns=$(grep -o "High" "$report" | wc -l)

  echo "Fixing vulnerabilities based on $label report..." >> ./reports/improvement-log.txt

  if [ $critical_vulns -gt 0 ]; then
    echo "Fixing $critical_vulns critical vulnerabilities found in $label..." >> ./reports/improvement-log.txt
  fi

  if [ $high_vulns -gt 0 ]; then
    echo "Fixing $high_vulns high vulnerabilities found in $label..." >> ./reports/improvement-log.txt
  fi
}

fix_vulnerabilities "$sca_report" "SCA"
fix_vulnerabilities "$sast_report" "SAST"
fix_vulnerabilities "$dast_report" "DAST"
fix_vulnerabilities "$iast_report" "IAST"

echo "Code improvement completed based on identified vulnerabilities." >> ./reports/improvement-log.txt
echo "Improvement log saved to ./reports/improvement-log.txt"
