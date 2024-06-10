#!/bin/bash

timeout=5
sleep_for=1

# Compile the TypeScript file to JavaScript
tsc program.ts > tsc_output.txt 2>&1

# Check if the compilation was successful
if [ $? -eq 0 ]; then
    # Run the JavaScript file with Node.js and redirect the output (stdout and stderr) to a file
    node program.js > node_output.txt &

    node_pid=$!

    find_process=$(ps -p $node_pid -o pid=)

    while [ ! -z "$find_process" ]; do
        find_process=$(ps -p $node_pid -o pid=)

        if [ "$timeout" -le "0" ]; then
            echo "Maximum runtime exceeded."
            kill -9 $node_pid
            exit 1
        fi

        timeout=$(($timeout - $sleep_for))
        sleep $sleep_for
    done

    cat node_output.txt
else
    echo "Compilation failed :"
    echo
    cat tsc_output.txt
fi

exit 0