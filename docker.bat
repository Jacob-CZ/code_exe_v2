@echo off

REM Define the list of directories
set directories=c_runner cpp_runner java_runner py_runner cs_runner go_runner js_runner ts_runner rust_runner

REM Loop through each directory
for %%d in (%directories%) do (
  REM Navigate to the directory
  cd %%d

  REM Build the Docker image
  docker build -t %%d .

  REM Navigate back to the parent directory
  cd ..
)