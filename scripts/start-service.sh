#!/bin/bash

function start_service() {
	local argument="$1";
	local _SERVICE=($(echo "$argument" | tr ':' '\n'))
	local PID=$(pgrep -f "${_SERVICE[1]}")
	if [ ! "$argument" ];then
		return 1;
	elif [ ! "$PID" ];then
		"${_SERVICE[0]}";
		start_service "$argument";
	else
		echo "started ${_SERVICE[0]} @PID=$PID";
	fi
}

for i in $(echo "${START_SERVICE}" | sed 's/,/ /g')
do
    start_service "${i}"
done;