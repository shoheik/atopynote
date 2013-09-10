#!/bin/bash

#export MOJO_MODE=production
#carton exec -- plackup --port 8002 ./script/knowhow3.psgi -E production
carton exec -- plackup --port 3000 ./script/atopynote.psgi &
echo $! > /tmp/atopynote.pid
