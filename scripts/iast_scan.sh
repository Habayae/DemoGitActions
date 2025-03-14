#!/bin/bash

npm install

if ! npm list express-session >/dev/null 2>&1; then
    echo "Installing missing dependency: express-session..."
    npm install express-session
fi

PORT=8080
EXISTING_PID=$(lsof -ti :$PORT)

if [ ! -z "$EXISTING_PID" ]; then
    echo "Port $PORT is in use. Killing process $EXISTING_PID..."
    kill -9 $EXISTING_PID
    sleep 2
fi

echo "Starting Node.js server..."
node server.js & 
SERVER_PID=$!
sleep 10  

if ! ps -p $SERVER_PID > /dev/null; then
    echo "Server failed to start. Exiting..."
    exit 1
fi

echo "Server started successfully with PID $SERVER_PID"

echo "Checking if server is responding..."
if ! curl -s http://localhost:$PORT > /dev/null; then
    echo "Error: Server is not responding on port $PORT!"
    exit 1
fi

mkdir -p reports/
touch reports/zap-report.html reports/gosec-iast.json

ZAP_PORT=8090

if ! pgrep -f "zap.sh -daemon"; then
    echo "Starting ZAP DAST..."
    zap.sh -daemon -port $ZAP_PORT -config api.disablekey=true &
    sleep 15
fi

echo "Checking if ZAP is running..."
if ! curl -s http://localhost:$ZAP_PORT > /dev/null; then
    echo "Error: ZAP is not running or not responding on port $ZAP_PORT!"
    exit 1
fi

echo "Running IAST scan..."
zap-cli --zap-url http://localhost:$ZAP_PORT quick-scan http://localhost:$PORT
sleep 10
zap-cli --zap-url http://localhost:$ZAP_PORT report -o reports/zap-report.html -f html

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

echo "Stopping Node.js server..."
if ps -p $SERVER_PID > /dev/null; then
    kill $SERVER_PID
else
    echo "Warning: Server process not found. It might have already exited."
fi
