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

airflow initdb

nohup airflow webserver $* >> ~/airflow/logs/webserver.logs &
nohup airflow worker $* >> ~/airflow/logs/worker.logs &
nohup airflow scheduler >> ~/airflow/logs/scheduler.logs &
nohup airflow flower >> ~/airflow/logs/flower.logs &

if [[ -n $1 ]]; then
  echo "docker container started in continous running mode"
  echo "you can kill this terminal if you wish and can use docker exec -it <container_id> bash "
  echo "anytime."
  while true; do sleep 1000; done
else 
	exec $@;
fi;