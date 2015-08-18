FROM dockerfile/ubuntu
MAINTAINER Piyush Mattoo <Piyush.Mattoo@software.dell.com> (@pmattoo)

# Download Doradus logstash
ENV LOGSTASH_HOME /opt/logstash
ENV LOGSTASH_VERSION='1.5.0'
ENV LOGSTASH_NAME="logstash-${LOGSTASH_VERSION}"
ENV LOGSTASH_URL="https://git.labs.dell.com/projects/BD/repos/logstash-output-batched_http/browse/artifacts/${LOGSTASH_NAME}.tar.gz?raw"

RUN mkdir ${LOGSTASH_HOME} && \
    cd ${LOGSTASH_HOME} && \
    wget https://git.labs.dell.com/projects/BD/repos/logstash-output-batched_http/browse/artifacts/logstash-1.5.0.tar.gz?raw && \
    tar -xzf logstash-1.5.0.tar.gz?raw && \
	mv ${LOGSTASH_NAME} logstash && \
    rm logstash-1.5.0.tar.gz?raw
	
# Add the script to run docker-doradus-logstash
ADD docker-logstash-redis.sh /usr/bin/
RUN chmod a+x /usr/bin/docker-logstash-redis.sh

# Install Redis.
RUN \
  cd /tmp && \
  wget http://download.redis.io/redis-stable.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  rm -rf /tmp/redis-stable*
	
# Any docker logs need to be mounted at /host/var/log. Typically, this means that
# a volume should be created mapping /var/lib/docker/containers to /host/var/log 
# in the container.
VOLUME ["/host/var/log", "/data"]

RUN mkdir /var/log/logstash
RUN mkdir ${LOGSTASH_HOME}/conf.d
ADD logstash.conf ${LOGSTASH_HOME}/conf.d/

ENTRYPOINT ["/usr/bin/docker-logstash-redis.sh"]

#CMD ["agent"]

# Expose ports.
EXPOSE 6379