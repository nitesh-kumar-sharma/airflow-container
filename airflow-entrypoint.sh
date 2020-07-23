#!/bin/bash

initial-setup.sh

airflow --help

cp /opt/init/airflow/airflow.cfg ~/airflow/

sed -i 's/${EXECUTOR}/'"${EXECUTOR}"'/g' ~/airflow/airflow.cfg
sed -i 's|${SQL_ALCHEMY_CONN}|'"${SQL_ALCHEMY_CONN}"'|g' ~/airflow/airflow.cfg
sed -i 's|${BROKER_URL}|'"${BROKER_URL}"'|g' ~/airflow/airflow.cfg
sed -i 's/${LOAD_EXAMPLES}/'"${LOAD_EXAMPLES}"'/g' ~/airflow/airflow.cfg
sed -i 's/${DEFAULT_QUEUE}/'"${DEFAULT_QUEUE}"'/g' ~/airflow/airflow.cfg
sed -i 's|${RESULT_BACKEND}|'"${RESULT_BACKEND}"'|g' ~/airflow/airflow.cfg
sed -i 's|${DAG_SCAN_INTERVAL}|'"${DAG_SCAN_INTERVAL}"'|g' ~/airflow/airflow.cfg

if [[ "${NODE_TYPE}" == "worker" ]];then
	nohup airflow worker >> ~/airflow/logs/worker.logs &
elif [[ "${NODE_TYPE}" == "scheduler" ]];then
	nohup airflow webserver >> ~/airflow/logs/webserver.logs &
elif [[ "${NODE_TYPE}" == "webserver" ]];then	
	nohup airflow webserver >> ~/airflow/logs/webserver.logs &
elif [[ "${NODE_TYPE}" == "flower" ]];then		
	nohup airflow flower >> ~/airflow/logs/flower.logs &
else
	nohup airflow initdb >> ~/airflow/logs/initdb.logs &
	sleep 5
	nohup airflow webserver >> ~/airflow/logs/webserver.logs &
	sleep 2
	nohup airflow scheduler >> ~/airflow/logs/scheduler.logs &
	sleep 2
	nohup airflow flower >> ~/airflow/logs/flower.logs &
fi;

if [[ -n $1 ]]; then
  echo "docker container started in continous running mode"
  echo "you can kill this terminal if you wish and can use docker exec -it <container_id> bash "
  echo "anytime."
  while true; do sleep 1000; done
else 
	exec $@;
fi;