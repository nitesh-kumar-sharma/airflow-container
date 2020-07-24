	FROM nikush001/python:3

LABEL MAINTAINER="Nitesh K. Sharma <sharma.nitesh590@gmail.com>"
RUN apk add cyrus-sasl-dev

ENV PATH=$PATH:/opt/init/airflow/
ENV	AIRFLOW_HOME=~/airflow \
	NODE_TYPE=${NODE_TYPE:-master} \
	DAG_DIR=${DAG_DIR:-~/airflow/dags} \
	LOG_DIR=${LOG_DIR:-~/airflow/logs} \
	EXECUTOR=${EXECUTOR:-SequentialExecutor} \
	SQL_ALCHEMY_CONN=${SQL_ALCHEMY_CONN:-sqlite:////usr/local/airflow/airflow.db} \
	LOAD_EXAMPLES=${LOAD_EXAMPLES:-false} \
	DEFAULT_QUEUE=${DEFAULT_QUEUE:-default} \
	RESULT_BACKEND=${RESULT_BACKEND} \
	DAG_SCAN_INTERVAL=${DAG_SCAN_INTERVAL:-300}

#Woker env	
ENV	WORKER_CONTAINER_REPO=${WORKER_CONTAINER_REPO} \
	WORKER_CONTAINER_TAG=${WORKER_CONTAINER_TAG} \
	KUBE_NAMESPACE=${KUBE_NAMESPACE:-default} \
	WORKER_SERVICE_ACCOUNT_NAME=${WORKER_SERVICE_ACCOUNT_NAME}

#git sync env
ENV	GIT_REPO=${GIT_REPO} \
	GIT_BRANCH=${GIT_BRANCH:-master} \
	GIT_SUB_PATH=${GIT_SUB_PATH} \
	GIT_USER=${GIT_USER} \
	GIT_PASS=${GIT_PASS}
	
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
	echo "export WORKER_CONTAINER_REPO=${WORKER_CONTAINER_REPO}" \
	echo "export WORKER_CONTAINER_TAG=${WORKER_CONTAINER_TAG}" \
	echo "export KUBE_NAMESPACE=${KUBE_NAMESPACE:-default}" \
	echo "export WORKER_SERVICE_ACCOUNT_NAME=${WORKER_SERVICE_ACCOUNT_NAME}" \
	echo "export LOG_DIR=${LOG_DIR}" \
	echo "export LOG_DIR=${DAG_DIR}" \
	echo "export GIT_REPO=${GIT_REPO}" \
	echo "export GIT_BRANCH=${GIT_BRANCH:-master}" \
	echo "export GIT_SUB_PATH=${GIT_SUB_PATH}" \
	echo "export GIT_USER=${GIT_USER}" \
	echo "export GIT_PASS=${GIT_PASS}"
	  
ADD ./airflow-entrypoint.sh /opt/init/airflow/
ADD ./airflow.cfg /opt/init/airflow/
RUN chmod -R +x /opt/init/airflow/
VOLUME usr/local/airflow
ENTRYPOINT ["/bin/bash", "-C", "airflow-entrypoint.sh","-d"]