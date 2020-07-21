#!/bin/bash

function wait_time()
{
	if [ -z "$1" ]; then echo "please provide time to wait for"; return 1;fi;
	
	local retry_seconds=$1    
	echo "requested sleep for service is ${retry_seconds}s ..."
	sleep $retry_seconds
}

wait_time "$WAIT_TIME"