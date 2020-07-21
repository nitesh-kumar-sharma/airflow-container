#!/bin/bash
if [ -n "$START_SERVICE" ] 
then
	start-service.sh
fi;
	
if [ -n "$WAIT_FOR_SERVICE" ]	
then
	wait-for-service.sh 
fi;

if [ -n "$WAIT_TIME" ]	
then
	wait-service-time.sh 
fi;