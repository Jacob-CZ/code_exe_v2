#!/bin/bash

timeout=5
sleep_for=1

# Compile the Java file and redirect the output (stdout and stderr) to a file
javac Program.java > javac_output.txt 2>&1

# Check if the program compiled successfully
if [ $? -eq 0 ]; then
    echo "Compilation successful, running the program:"
    # Run the program with a timeout
    java Program > java_run_output.txt &

    java_pid=$!

    find_process=$(ps -p $java_pid -o pid=)

    while [ ! -z "$find_process" ]; do
        find_process=$(ps -p $java_pid -o pid=)

        if [ "$timeout" -le "0" ]; then
            echo "Timeout"
            kill -9 $java_pid
            exit 1
        fi

        timeout=$(($timeout - $sleep_for))
        sleep $sleep_for
    done

    cat java_run_output.txt
else
    echo "Compilation failed. Here's the output:"
    cat javac_output.txt
fi

exit 0