#!/bin/bash

timeout=5
sleep_for=1

python3 program.py > python_output.txt &

python_pid=$!

find_process=$(ps aux | grep -v "grep" | grep "python3")

while [ ! -z "$find_process" ]; do
    find_process=$(ps aux | grep -v "grep" | grep "python3")

    if [ "$timeout" -le "0" ]; then
        pkill $python_pid
      echo "Timeout"
      exit 1
    fi

    timeout=$(($timeout - $sleep_for))
    sleep $sleep_for
done
cat python_output.txt
exit 0