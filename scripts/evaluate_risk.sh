#!/bin/bash

echo "Evaluating risk based on scan reports..."

sca_report="./reports/sca-report.txt"
sast_report="./reports/sast-report.json"
dast_report="./reports/zap-report.html"
dast_katana="./reports/katana-dast.json"
iast_report="./reports/iact-report.html"

if [ ! -f "$sca_report" ] ; then
  echo "SCA report not found!"
  exit 1
fi

if [ ! -f "$sast_report" ]; then
  echo "SAST report not found!"
  exit 1
fi

if [ ! -f "$dast_report" ] && [ ! -s "$dast_katana" ]; then
  echo "DAST report not found!"
  #exit 1
fi

if [ ! -f "$iast_report" ]; then
  echo "IAST report not found!"
  exit 1
fi

risk_report="./risk-evaluation-report.txt"

if [ -f "$risk_report" ]; then
  rm "$risk_report"
fi

echo "Creating risk evaluation report..." > "$risk_report"
echo "======================================" >> "$risk_report"

echo "Analyzing SCA report..." >> "$risk_report"
sca_critical=$(grep -o "Critical" "$sca_report" | wc -l)
sca_high=$(grep -o "High" "$sca_report" | wc -l)
sca_medium=$(grep -o "Medium" "$sca_report" | wc -l)
sca_low=$(grep -o "Low" "$sca_report" | wc -l)

echo "SCA Critical: $sca_critical" >> "$risk_report"
echo "SCA High: $sca_high" >> "$risk_report"
echo "SCA Medium: $sca_medium" >> "$risk_report"
echo "SCA Low: $sca_low" >> "$risk_report"

echo "Analyzing SAST report..." >> "$risk_report"
sast_critical=$(grep -o "Critical" "$sast_report" | wc -l)
sast_high=$(grep -o "High" "$sast_report" | wc -l)
sast_medium=$(grep -o "Medium" "$sast_report" | wc -l)
sast_low=$(grep -o "Low" "$sast_report" | wc -l)

echo "SAST Critical: $sast_critical" >> "$risk_report"
echo "SAST High: $sast_high" >> "$risk_report"
echo "SAST Medium: $sast_medium" >> "$risk_report"
echo "SAST Low: $sast_low" >> "$risk_report"

echo "Analyzing DAST report..." >> "$risk_report"
dast_critical=$(grep -o "Critical" "$dast_report" | wc -l)
dast_high=$(grep -o "High" "$dast_report" | wc -l)
dast_medium=$(grep -o "Medium" "$dast_report" | wc -l)
dast_low=$(grep -o "Low" "$dast_report" | wc -l)

echo "DAST Critical: $dast_critical" >> "$risk_report"
echo "DAST High: $dast_high" >> "$risk_report"
echo "DAST Medium: $dast_medium" >> "$risk_report"
echo "DAST Low: $dast_low" >> "$risk_report"

echo "Analyzing IAST report..." >> "$risk_report"
iast_critical=$(grep -o "Critical" "$iast_report" | wc -l)
iast_high=$(grep -o "High" "$iast_report" | wc -l)
iast_medium=$(grep -o "Medium" "$iast_report" | wc -l)
iast_low=$(grep -o "Low" "$iast_report" | wc -l)

echo "IAST Critical: $iast_critical" >> "$risk_report"
echo "IAST High: $iast_high" >> "$risk_report"
echo "IAST Medium: $iast_medium" >> "$risk_report"
echo "IAST Low: $iast_low" >> "$risk_report"

echo "======================================" >> "$risk_report"
total_critical=$((sca_critical + sast_critical + dast_critical + iast_critical))
total_high=$((sca_high + sast_high + dast_high + iast_high))
total_medium=$((sca_medium + sast_medium + dast_medium + iast_medium))
total_low=$((sca_low + sast_low + dast_low + iast_low))

echo "Total Critical: $total_critical" >> "$risk_report"
echo "Total High: $total_high" >> "$risk_report"
echo "Total Medium: $total_medium" >> "$risk_report"
echo "Total Low: $total_low" >> "$risk_report"

if [ $total_critical -gt 0 ]; then
  echo "Overall Risk: Critical" >> "$risk_report"
elif [ $total_high -gt 0 ]; then
  echo "Overall Risk: High" >> "$risk_report"
elif [ $total_medium -gt 0 ]; then
  echo "Overall Risk: Medium" >> "$risk_report"
else
  echo "Overall Risk: Low" >> "$risk_report"
fi

echo "Risk evaluation report saved to $risk_report"
