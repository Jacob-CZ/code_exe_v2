#!/bin/bash

timeout=5
sleep_for=1

# Build the Go program and redirect the output (stdout and stderr) to a file
go build -o program program.go > go_build_output.txt 2>&1

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Build successful, running the program:"
    # Run the program with a timeout
    ./program > go_run_output.txt &

    go_pid=$!

    find_process=$(ps -p $go_pid -o pid=)

    while [ ! -z "$find_process" ]; do
        find_process=$(ps -p $go_pid -o pid=)

        if [ "$timeout" -le "0" ]; then
            echo "Timeout"
            kill -9 $go_pid
            exit 1
        fi

        timeout=$(($timeout - $sleep_for))
        sleep $sleep_for
    done

    cat go_run_output.txt
else
    echo "Build failed. Here's the output:"
    cat go_build_output.txt
fi

exit 0