#!/bin/bash

PIDFILE=/tmp/mailworker.pid
PROCESS_ID=`cat $PIDFILE`
kill $PROCESS_ID
rm $PIDFILE


