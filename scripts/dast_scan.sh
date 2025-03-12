#!/bin/bash

node server.js &
SERVER_PID=$!
sleep 10  

changed_files=$(git diff --name-only HEAD~1 HEAD)
echo "Changed files: $changed_files"

web_languages="\.html$|\.css$|\.js$|\.php$|\.ts$|\.vue$|\.react$|\.angular$"
software_languages="\.java$|\.py$|\.go$|\.c$|\.cpp$|\.rb$|\.sh$"

mkdir -p reports/
touch reports/zap-report.html reports/katana-dast.json

if echo "$changed_files" | grep -E "$web_languages"; then
    zap.sh -daemon -port 8080 -config api.disablekey=true &  
    sleep 10  
    zap-cli quick-scan --url http://localhost:3000  
    zap-cli report -o reports/zap-report.html -f html  
fi

if echo "$changed_files" | grep -E "$software_languages"; then
    katana -u http://localhost:3000 -o reports/katana-dast.json &  
    sleep 10  
fi

if [ -z "$changed_files" ] || ! echo "$changed_files" | grep -qE "$web_languages|$software_languages"; then
    zap.sh -daemon -port 8080 -config api.disablekey=true &  
    sleep 10  
    zap-cli quick-scan --url http://localhost:3000  
    zap-cli report -o reports/zap-report.html -f html  
fi

if [ ! -s "reports/zap-report.html" ] && [ ! -s "reports/katana-dast.json" ]; then
    exit 1  
else
    echo "DAST scan passed successfully."
fi

kill $SERVER_PID
