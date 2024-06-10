#!/bin/bash

timeout=5
sleep_for=1

# Run the JavaScript file with Node.js and redirect the output (stdout and stderr) to a file
node program.js > node_output.txt &

node_pid=$!

find_process=$(ps aux | grep -v "grep" | grep "node")

while [ ! -z "$find_process" ]; do
    find_process=$(ps aux | grep -v "grep" | grep "node")

    if [ "$timeout" -le "0" ]; then
        pkill $node_pid
        echo "Timeout"
        exit 1
    fi

    timeout=$(($timeout - $sleep_for))
    sleep $sleep_for
done

cat node_output.txt

exit 0