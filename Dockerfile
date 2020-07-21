FROM nikush001/python:3
LABEL MAINTAINER="Nitesh K. Sharma <sharma.nitesh590@gmail.com>"

ENV PATH=$PATH:/opt/init/airflow/
ENV	AIRFLOW_HOME=~/airflow \
	EXECUTOR=${EXECUTOR:-SequentialExecutor} \
	SQL_ALCHEMY_CONN=${SQL_ALCHEMY_CONN:-sqlite:////usr/local/airflow/airflow.db} \
	LOAD_EXAMPLES=${LOAD_EXAMPLES:-false} \
	DEFAULT_QUEUE=${DEFAULT_QUEUE:-default} 
	
RUN pip install apache-airflow[postgres,rabbitmq,celery,kubernetes] && \
	echo "export AIRFLOW_HOME=${AIRFLOW_HOME}" \
	echo "export EXECUTOR=${EXECUTOR}" \
	echo "export SQL_ALCHEMY_CONN=${SQL_ALCHEMY_CONN}" \
	echo "export LOAD_EXAMPLES=${LOAD_EXAMPLES}" \
	echo "export DEFAULT_QUEUE=${DEFAULT_QUEUE}"
	  
ADD ./airflow-entrypoint.sh /opt/init/airflow/
ADD ./airflow.cfg /opt/init/airflow/
RUN chmod -R +x /opt/init/airflow/
VOLUME usr/local/airflow
ENTRYPOINT ["/bin/bash", "-C", "airflow-entrypoint.sh","-d"]