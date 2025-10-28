FROM ubuntu:20.04

ENV HADOOP_VERSION=3.4.2
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_INSTALL=$HADOOP_HOME
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV HADOOP_YARN_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"

RUN apt update && apt install -y openjdk-11-jdk ssh rsync wget curl net-tools

RUN groupadd --gid 1000 hadoop && \
    useradd  --uid 1000 --gid 1000 --create-home --shell /bin/bash hadoop

WORKDIR /home/hadoop

RUN wget https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz \
    && tar -xzvf hadoop-$HADOOP_VERSION.tar.gz -C /usr/local/ \
    && mv /usr/local/hadoop-$HADOOP_VERSION /usr/local/hadoop \
    && rm hadoop-$HADOOP_VERSION.tar.gz \
    && chown -R hadoop:hadoop /usr/local/hadoop

# Crea os dir como root pero co dono correcto hadoop:hadoop (máis fiable ca usar ~)
RUN install -d -o hadoop -g hadoop /home/hadoop/namenode /home/hadoop/datanode

# Copiar archivos de configuración de Hadoopdoc
COPY conf/core-site.xml $HADOOP_HOME/etc/hadoop/
COPY conf/hdfs-site.xml $HADOOP_HOME/etc/hadoop/
COPY conf/mapred-site.xml $HADOOP_HOME/etc/hadoop/
COPY conf/yarn-site.xml $HADOOP_HOME/etc/hadoop/


# Cambiamos a usuario hadoop
USER hadoop
# (opcional) verifica en build que existen
RUN ls -ld /home/hadoop /home/hadoop/namenode /home/hadoop/datanode

RUN mkdir -p ~/.ssh && \
    ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 700 ~/.ssh && \
    chmod 600 ~/.ssh/authorized_keys


EXPOSE 8088 8042 50070 50075 50090 8020 9000

CMD bash
