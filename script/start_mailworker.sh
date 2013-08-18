#!/bin/bash

carton exec -- ./script/MailWorker.pl 2>&1 > /tmp/mailworker.log &
echo $! > /tmp/mailworker.pid

