FROM ubuntu:20.04
ARG HADOOP_VERSION=3.4.2
# Variables de entorno
# TODO
# igual que el .bashrc de la práctica

# Evitar preguntas interactivas en apt
ENV DEBIAN_FRONTEND=noninteractive


ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 \
    HADOOP_HOME=/usr/local/hadoop \
    HADOOP_INSTALL=/usr/local/hadoop \
    HADOOP_MAPRED_HOME=/usr/local/hadoop \
    HADOOP_COMMON_HOME=/usr/local/hadoop \
    HADOOP_HDFS_HOME=/usr/local/hadoop \
    HADOOP_YARN_HOME=/usr/local/hadoop \
    HADOOP_COMMON_LIB_NATIVE_DIR=/usr/local/hadoop/lib/native \
    PATH=$PATH:/usr/local/hadoop/sbin:/usr/local/hadoop/bin \
    HADOOP_OPTS="-Djava.library.path=/usr/local/hadoop/lib/native"

# Instalamos java (openjdk-11-jdk ssh rsync wget curl net-tools)
# TODO
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-11-jdk-headless \
    openssh-client \
    openssh-server \
    rsync wget curl net-tools ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# creamos o usuario hadoop
RUN groupadd --gid 1000 hadoop && \
    useradd  --uid 1000 --gid 1000 --create-home --shell /bin/bash hadoop

# Especificamos o directorio de traballo (/home/hadoop)
WORKDIR /home/hadoop

# Descargamos e descomprimos o https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION-lean.tar.gz
# en /usr/local, renomeamos a /usr/local/hadoop
#TODO
RUN wget https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -P /tmp && \
    tar -xzf /tmp/hadoop-${HADOOP_VERSION}.tar.gz -C /usr/local && \
    mv /usr/local/hadoop-${HADOOP_VERSION} /usr/local/hadoop && \
    rm /tmp/hadoop-${HADOOP_VERSION}.tar.gz && \
    chown -R hadoop:hadoop /usr/local/hadoop

# Crea os dir como root pero co dono correcto hadoop:hadoop (máis fiable ca usar ~)
RUN install -d -o hadoop -g hadoop /home/hadoop/namenode /home/hadoop/datanode

# Copiar archivos de configuración de Hadoop
COPY conf/core-site.xml $HADOOP_HOME/etc/hadoop/
COPY conf/hdfs-site.xml $HADOOP_HOME/etc/hadoop/
COPY conf/mapred-site.xml $HADOOP_HOME/etc/hadoop/
COPY conf/yarn-site.xml $HADOOP_HOME/etc/hadoop/

# Cambiamos a usuario hadoop
# todo
USER hadoop
WORKDIR /home/hadoop

# Configuramos o ssh
RUN mkdir -p ~/.ssh && \
    ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 700 ~/.ssh && \
    chmod 600 ~/.ssh/authorized_keys

# Espoñemos os portos necesarios
# TODO
EXPOSE 22 9870 9864 8088 8042 8020 9000

CMD bash