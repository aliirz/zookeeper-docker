FROM aliirz/base

MAINTAINER ali.raza

ENV ZOOKEEPER_VERSION 3.4.14

#Download Zookeeper
RUN wget -q http://mirror.vorboss.net/apache/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz && \
wget -q https://www.apache.org/dist/zookeeper/KEYS && \
wget -q https://www.apache.org/dist/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz.asc && \
wget -q https://www.apache.org/dist/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz.md5

#Verify download
RUN md5sum -c zookeeper-3.4.14.tar.gz.md5 && \
gpg --import KEYS && \
gpg --verify zookeeper-3.4.14.tar.gz.asc

#Install
RUN tar -xzf zookeeper-3.4.14.tar.gz -C /opt

#Configure
RUN mv /opt/zookeeper-3.4.14/conf/zoo_sample.cfg /opt/zookeeper-3.4.14/conf/zoo.cfg

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV ZK_HOME /opt/zookeeper-3.4.14
RUN sed  -i "s|/tmp/zookeeper|$ZK_HOME/data|g" $ZK_HOME/conf/zoo.cfg; mkdir $ZK_HOME/data

ADD start-zk.sh /usr/bin/start-zk.sh 
EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper-3.4.14
VOLUME ["/opt/zookeeper-3.4.14/conf", "/opt/zookeeper-3.4.14/data"]

CMD /usr/sbin/sshd && bash /usr/bin/start-zk.sh
