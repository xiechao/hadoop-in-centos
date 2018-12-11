FROM centos:latest
USER root
ARG HADOOP_VERSION=3.1.1
ADD start.sh /start.sh
ADD config/ssh-config /root/.ssh/config
ADD package/hadoop-3.1.1.tar.gz /usr/local
RUN yum clean all; \
    rpm --rebuilddb; \
    yum install -y epel-release https://centos7.iuscommunity.org/ius-release.rpm dos2unix initscripts curl which tar sudo rsync openssh-server openssh-clients java && dos2unix start.sh; \
    yum update -y libselinux; \
    yum install python36u python36u-pip -y; \
    ln -s /bin/python3.6 /bin/python3; \
    ln -s /bin/pip3.6 /bin/pip3; \
    chmod 600 /root/.ssh/config; \
    chown root:root /root/.ssh/config; \
    echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config; \
    echo "/usr/sbin/sshd" >> ~/.bashrc; \
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa; \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys; \
    /usr/bin/ssh-keygen -A

ENV JAVA_HOME=/usr
ENV PATH=$PATH:$JAVA_HOME/bin
# RUN rm /usr/bin/java && ln -s $JAVA_HOME/bin/java /usr/bin/java

# hadoop
# RUN curl -s http://apache.tt.co.kr/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz | tar -xz -C /usr/local/
WORKDIR /usr/local
RUN ln -s ./hadoop-$HADOOP_VERSION hadoop
RUN echo `ls`
WORKDIR /usr/local/hadoop
RUN mkdir -p logs

ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_PREFIX=/usr/local/hadoop
ENV HADOOP_COMMON_HOME=/usr/local/hadoop
ENV HADOOP_HDFS_HOME=/usr/local/hadoop
ENV HADOOP_MAPRED_HOME=/usr/local/hadoop
ENV HADOOP_YARN_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR=$HADOOP_PREFIX/etc/hadoop

ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root

ENV PATH $PATH:$HADOOP_PREFIX/bin
ENV PATH $PATH:$HADOOP_PREFIX/sbin

# RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_PREFIX=/usr/local/hadoop\n:' $HADOOP_CONF_DIR/hadoop-env.sh
# RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_CONF_DIR/hadoop-env.sh

#copy config
# ADD config/core-site.xml $HADOOP_PREFIX/etc/hadoop/core-site.xml
# ADD config/hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
# ADD config/mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
# ADD config/yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
# ADD config/slaves $HADOOP_PREFIX/etc/hadoop/slaves

RUN chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE 10020 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
#Other ports
EXPOSE 49707 22

EXPOSE 22
CMD [ "sh","start.sh" ]