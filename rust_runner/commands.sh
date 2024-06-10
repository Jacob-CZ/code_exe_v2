#!/bin/bash

timeout=5
sleep_for=1
# Compile the Rust file and redirect the output (stdout and stderr) to a file
rustc program.rs > rustc_output.txt 2>&1

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
            pkill -9 $program_pid
            exit 1
            echo "didnt exit"
        fi

        timeout=$(($timeout - $sleep_for))
        sleep $sleep_for
    done


else
    echo "Compilation failed. Here's the output:"
    cat rustc_output.txt
fi

exit 0