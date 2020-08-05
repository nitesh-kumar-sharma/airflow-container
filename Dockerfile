FROM nikush001/python:3
LABEL MAINTAINER="Nitesh K. Sharma <sharma.nitesh590@gmail.com>"

RUN apk add cyrus-sasl-dev

ENV PATH=$PATH:/opt/init/airflow/
ENV	AIRFLOW_HOME=/root/airflow \
	MODE=${MODE:-standalone} \
	NODE_TYPE=${NODE_TYPE:-master} \
	DAG_DIR=${DAG_DIR} \
	LOG_DIR=${LOG_DIR} \
	EXECUTOR=${EXECUTOR:-SequentialExecutor} \
	SQL_ALCHEMY_CONN=${SQL_ALCHEMY_CONN:-sqlite:////usr/local/airflow/airflow.db} \
	LOAD_EXAMPLES=${LOAD_EXAMPLES:-false} \
	DEFAULT_QUEUE=${DEFAULT_QUEUE:-default} \
	RESULT_BACKEND=${RESULT_BACKEND} \
	DAG_SCAN_INTERVAL=${DAG_SCAN_INTERVAL:-300}
	
RUN mkdir -p ${DAG_DIR} ${LOG_DIR} && \
	pip install apache-airflow[postgres,rabbitmq,celery,kubernetes,crypto,postgres,hive,jdbc] && \
	echo "export AIRFLOW_HOME=${AIRFLOW_HOME}" \
	echo "export NODE_TYPE=${NODE_TYPE}" \
	echo "export EXECUTOR=${EXECUTOR}" \
	echo "export SQL_ALCHEMY_CONN=${SQL_ALCHEMY_CONN}" \
	echo "export LOAD_EXAMPLES=${LOAD_EXAMPLES}" \
	echo "export DEFAULT_QUEUE=${DEFAULT_QUEUE}" \
	echo "export RESULT_BACKEND=${RESULT_BACKEND}" \
	echo "export DAG_SCAN_INTERVAL=${DAG_SCAN_INTERVAL}" \
	echo "export LOG_DIR=${LOG_DIR}" \
	echo "export DAG_DIR=${DAG_DIR}" \
	echo "export MODE=${MODE}"
	  
ADD ./airflow-entrypoint.sh /opt/init/airflow/
ADD ./airflow.cfg /opt/init/airflow/
RUN chmod -R +x /opt/init/airflow/
VOLUME usr/local/airflow
ENTRYPOINT ["/bin/bash", "-C", "airflow-entrypoint.sh","-d"]