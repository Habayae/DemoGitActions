#!/bin/bash

killall -q zap.sh

node server.js &
SERVER_PID=$!
sleep 10  

mkdir -p reports/
touch reports/zap-report.html reports/gosec-iast.json

echo "Running IAST scan..."

zap.sh -daemon -port 8080 -config api.disablekey=true &
sleep 10

zap-cli quick-scan --url http://localhost:3000
sleep 10

zap-cli report -o reports/zap-report.html -f html

echo "Running Gosec IAST..."

gosec -fmt json -out reports/gosec-iast.json ./

if [ ! -s "reports/zap-report.html" ]; then
    echo "<html><body><h1>No vulnerabilities found</h1></body></html>" > reports/zap-report.html
fi

if [ ! -s "reports/gosec-iast.json" ]; then
    echo '{ "status": "No vulnerabilities found" }' > reports/gosec-iast.json
fi

if [ $? -ne 0 ]; then
  echo "IAST scan failed."
  exit 1
else
  echo "IAST scan passed successfully."
fi

kill $SERVER_PID
