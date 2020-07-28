#!/bin/bash

initial-setup.sh

if [[ "${EXECUTOR}" -ne "KubernetesExecutor" ]];then
	airflow --help
	cp /opt/init/airflow/airflow.cfg ~/airflow/
	
	sed -i 's/${EXECUTOR}/'"${EXECUTOR}"'/g' ~/airflow/airflow.cfg
	sed -i 's|${SQL_ALCHEMY_CONN}|'"${SQL_ALCHEMY_CONN}"'|g' ~/airflow/airflow.cfg
	sed -i 's|${BROKER_URL}|'"${BROKER_URL}"'|g' ~/airflow/airflow.cfg
	sed -i 's/${DEFAULT_QUEUE}/'"${DEFAULT_QUEUE}"'/g' ~/airflow/airflow.cfg
	sed -i 's|${RESULT_BACKEND}|'"${RESULT_BACKEND}"'|g' ~/airflow/airflow.cfg
	
	sed -i 's/${LOAD_EXAMPLES}/'"${LOAD_EXAMPLES}"'/g' ~/airflow/airflow.cfg
	sed -i 's|${DAG_SCAN_INTERVAL}|'"${DAG_SCAN_INTERVAL}"'|g' ~/airflow/airflow.cfg	
	sed -i 's|${DAG_DIR}|'"${DAG_DIR}"'|g' ~/airflow/airflow.cfg
	sed -i 's|${LOG_DIR}|'"${LOG_DIR}"'|g' ~/airflow/airflow.cfg

fi;

if [[ "${NODE_TYPE}" == "worker" ]];then
	airflow worker
elif [[ "${NODE_TYPE}" == "scheduler" ]];then
	airflow scheduler
elif [[ "${NODE_TYPE}" == "webserver" ]];then	
	airflow webserver
elif [[ "${NODE_TYPE}" == "flower" ]];then		
	airflow flower
elif [[ "${NODE_TYPE}" == "init" ]];then
	airflow initdb
else
	nohup airflow initdb &
	sleep 5
	nohup airflow webserver &
	sleep 2
	nohup airflow scheduler &
	sleep 2
	nohup airflow flower &
	sleep 2
	nohup airflow worker &
fi;	

if [[ -n $1 ]]; then
  echo "docker container started in continous running mode"
  echo "you can kill this terminal if you wish and can use docker exec -it <container_id> bash "
  echo "anytime."
  while true; do sleep 1000; done
else 
	exec $@;
fi;