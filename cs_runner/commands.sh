#!/bin/bash

timeout=5
sleep_for=1
dotnet publish -c Release -o out > dotnet_publish_output.txt 2>&1

# Check if the publish was successful
if [ $? -eq 0 ]; then
    # Run the application with a timeout
    dotnet out/app.dll > dotnet_run_output.txt &

    dotnet_pid=$!

    find_process=$(ps -p $dotnet_pid -o pid=)

    while [ ! -z "$find_process" ]; do
        find_process=$(ps -p $dotnet_pid -o pid=)

        if [ "$timeout" -le "0" ]; then
            echo "Maximum runtime exceeded."
            kill -9 $dotnet_pid
            exit 1
        fi

        timeout=$(($timeout - $sleep_for))
        sleep $sleep_for
    done

    cat dotnet_run_output.txt
else
    echo "Compilation failed :"
    echo
    cat dotnet_publish_output.txt
fi

exit 0