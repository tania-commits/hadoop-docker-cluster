FROM ubuntu:20.04
ARG HADOOP_VERSION=3.4.2
# Variables de entorno
# TODO


# Instalamos java (openjdk-11-jdk ssh rsync wget curl net-tools)
# TODO

# creamos o usuario hadoop
RUN groupadd --gid 1000 hadoop && \
    useradd  --uid 1000 --gid 1000 --create-home --shell /bin/bash hadoop

# Especificamos o directorio de traballo (/home/hadoop)
WORKDIR /home/hadoop

# Descargamos e descomprimos o https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION-lean.tar.gz
# en /usr/local, renomeamos a /usr/local/hadoop
#TODO

# Crea os dir como root pero co dono correcto hadoop:hadoop (máis fiable ca usar ~)
RUN install -d -o hadoop -g hadoop /home/hadoop/namenode /home/hadoop/datanode

# Copiar archivos de configuración de Hadoop
COPY conf/core-site.xml $HADOOP_HOME/etc/hadoop/
COPY conf/hdfs-site.xml $HADOOP_HOME/etc/hadoop/
COPY conf/mapred-site.xml $HADOOP_HOME/etc/hadoop/
COPY conf/yarn-site.xml $HADOOP_HOME/etc/hadoop/


# Cambiamos a usuario hadoop
# todo

# Configuramos o ssh
RUN mkdir -p ~/.ssh && \
    ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 700 ~/.ssh && \
    chmod 600 ~/.ssh/authorized_keys


# Espoñemos os portos necesarios
# TODO

CMD bash
