#!/bin/sh

# Very basic client testing.


set -e

export BASE_PATH=../../
export PORT=1888
export SUB_TIMEOUT=1

# Start broker
../../src/mosquitto -p ${PORT}  &
export MOSQ_PID=$!
sleep 0.5

# Kill broker on exit
trap "kill $MOSQ_PID" EXIT


# Simple subscribe test - single message from $SYS
${BASE_PATH}/client/mosquitto_sub -p ${PORT} -W ${SUB_TIMEOUT} -C 1 -t '$SYS/broker/uptime'
echo "Simple subscribe ok"

# Simple publish/subscribe test - single message from mosquitto_pub
${BASE_PATH}/client/mosquitto_sub -p ${PORT} -W ${SUB_TIMEOUT} -C 1 -t 'single/test' &
export SUB_PID=$!
${BASE_PATH}/client/mosquitto_pub -p ${PORT} -t 'single/test' -m 'single-test'
kill ${SUB_PID} || true
echo "Simple publish/subscribe ok"

# Publish a file and subscribe, do we get at least that many lines?
export TEST_LINES="46"
${BASE_PATH}/client/mosquitto_sub -p ${PORT} -W ${SUB_TIMEOUT} -C ${TEST_LINES} -t 'file-publish' &
export SUB_PID=$!
${BASE_PATH}/client/mosquitto_pub -p ${PORT} -t 'file-publish' -f "./test_qnx.sh"
kill ${SUB_PID} || true
echo "File publish ok"

# Publish a file from stdin and subscribe, do we get at least that many lines?
export TEST_LINES="46"
${BASE_PATH}/client/mosquitto_sub -p ${PORT} -W ${SUB_TIMEOUT} -C ${TEST_LINES} -t 'file-publish' &
export SUB_PID=$!
${BASE_PATH}/client/mosquitto_pub -p ${PORT} -t 'file-publish' -l < "./test_qnx.sh"
kill ${SUB_PID} || true
echo "stdin publish ok"
