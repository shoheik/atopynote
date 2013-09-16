#!/bin/bash

carton exec -- perl ./script/MailWorker.pl 2>&1 > /tmp/mailworker.log &
echo $! > /tmp/mailworker.pid

