FROM ipman1971/debian-zulu

MAINTAINER Ipman1971 <ipman1971@gmail.com>

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="hadoop-zulu" \
      org.label-schema.description="Hadoop in pseudo-distributed mode" \
      org.label-schema.vcs-url="https://github.com/ipman1971/hadoop-zulu" \
      org.label-schema.vendor="Ipman1971" \
      org.label-schema.version="1.0.0" \
      com.ipman1971.baseimage-contents='{"contents": [{"name": "hadoop", "version": "2.9.1"}]}'

USER root

ENV HADOOP_VERSION 2.9.1
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN set -x && \
    apt-get -qq update && \
    apt-get -qqy install ssh rsync wget && \
    ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -P "" && \
    cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys && \
    wget -O /hadoop.tar.gz -q http://apache.rediris.es/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar xfz hadoop.tar.gz && \
    mv /hadoop-${HADOOP_VERSION} /usr/local/hadoop && \
    rm /hadoop.tar.gz && \
    mkdir -p $HADOOP_HOME/hdfs/namenode && \
    mkdir -p $HADOOP_HOME/hdfs/datanode && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*

ADD scripts/hadoop-services.sh $HADOOP_HOME/hadoop-services.sh

# setup configs - [standalone, pseudo-distributed mode, fully distributed mode
# NOTE: Directly using COPY/ ADD will NOT work if you are NOT using absolute paths inside the docker image.
# Temporary files: http://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s18.html
COPY config/ /tmp/

RUN set -x && \
    mv /tmp/ssh_config $HOME/.ssh/config && \
    mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    chmod 744 -R $HADOOP_HOME && \
    $HADOOP_HOME/bin/hdfs namenode -format

# run hadoop services
ENTRYPOINT $HADOOP_HOME/hadoop-services.sh; bash
