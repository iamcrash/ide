#!/bin/bash

# export $(grep -v '^#' ./user.env | xargs)
# 
# export $(grep -v '^#' ./home.env | xargs)

# env $(cat user.env home.env | grep -v "#" | xargs) docker-compose config

# env -i PATH=$PATH docker-compose config

source .env

docker-compose build $*



