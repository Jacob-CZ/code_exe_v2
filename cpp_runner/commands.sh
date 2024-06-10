#!/bin/bash

timeout=5
sleep_for=1

# Compile the C++ file and redirect the output (stdout and stderr) to a file
g++ program.cpp -o program > gcc_output.txt 2>&1

# Check if the program compiled successfully
if [ $? -eq 0 ]; then
    echo "Compilation successful, running the program:"
    # Run the program with a timeout
    ./program > program_output.txt &

    program_pid=$!

    find_process=$(ps -p $program_pid -o pid=)

    while [ ! -z "$find_process" ]; do
        find_process=$(ps -p $program_pid -o pid=)

        if [ "$timeout" -le "0" ]; then
            echo "Timeout"
            kill -9 $program_pid
            exit 1
        fi

        timeout=$(($timeout - $sleep_for))
        sleep $sleep_for
    done

    cat program_output.txt
else
    echo "Compilation failed. Here's the output:"
    cat gcc_output.txt
fi

exit 0