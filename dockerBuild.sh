#!/bin/bash

# Define the list of directories
directories=("c_runner" "cpp_runner" "java_runner" "py_runner" "cs_runner" "go_runner" "js_runner" "ts_runner")

# Loop through each directory
for dir in "${directories[@]}"
do
  # Navigate to the directory
  cd $dir

  # Build the Docker image
  docker build -t $dir .

  # Navigate back to the parent directory
  cd ..
done