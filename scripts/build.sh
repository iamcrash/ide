#!/bin/bash

# Colors
_red_color=$(tput setaf 1)
_green_color=$(tput setaf 2)
_reset_color=$(tput sgr0)

_logfile=build.log
_break="#############"
_build="BUILD"
_command="Command: docker-compose build $*"
_now="Time: $(date +"%T-%m-%d-%Y")"

# Source environment
source .env

# Log
cat << EOF &>> $_logfile
  ${_green_color}
  ${_break}
  ${_build}
  ${_command}
  ${_now}
  ${_break}
  ${_reset_color}
EOF

# Build
echo "Running: ${_command}"
# docker-compose build $* &>> $_logfile
docker-compose build $* | tee -a $_logfile
echo "Finished..."
