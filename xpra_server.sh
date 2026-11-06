#!/bin/bash

PORT=8080
#APP=xterm
#START=--start=$APP

OPTIONS="--speaker=no --microphone=no"

# Need to be set in parent shell
#export DISPLAY=:100
# fish:
#set --erase --global DISPLAY
#set -Ux DISPLAY :100

xpra start $DISPLAY --bind-tcp=0.0.0.0:$PORT $OPTIONS $START
