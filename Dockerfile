FROM openjdk:8u102-jre

MAINTAINER ty.auvil@gmail.com

ENV DUMB_VERSION=1.1.3 \
    DEBIAN_FRONTEND=noninteractive

ADD https://github.com/Yelp/dumb-init/releases/download/v${DUMB_VERSION}/dumb-init_${DUMB_VERSION}_amd64 /bin/dumb-init

COPY docker-entrypoint.sh /bin/docker-entrypoint.sh

RUN echo "deb http://www.ubnt.com/downloads/unifi/debian unifi5 ubiquiti" > \
    /etc/apt/sources.list.d/20ubiquiti.list && \
    echo "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen" > \
    /etc/apt/sources.list.d/21mongodb.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && \
    apt-get -q update && \
    apt-get install -qy --force-yes --no-install-recommends unifi && \
    apt-get -q clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /var/lib/unifi /usr/lib/unifi/data && \
    chmod +x /bin/docker-entrypoint.sh /bin/dumb-init

EXPOSE 8080/tcp 8081/tcp 8443/tcp 8843/tcp 8880/tcp 3478/udp

USER nobody

ENTRYPOINT ["/bin/docker-entrypoint.sh"]

CMD ["/usr/bin/java", "-Xmx256M", "-jar", "/usr/lib/unifi/lib/ace.jar", "start"]
