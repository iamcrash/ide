#!/bin/bash

# export $(grep -v '^#' ./user.env | xargs)
# 
# export $(grep -v '^#' ./home.env | xargs)

# env $(cat user.env home.env | grep -v "#" | xargs) docker-compose config

# env -i PATH=$PATH docker-compose config

source .env

_logfile=.log

_break_="#############\n"

_NOW=$(date +"%T-%m-%d-%Y")

echo "${_break_}" "# ${_NOW}\n" "${_break_}" >> $_logfile

docker-compose build $* >> $_logfile



