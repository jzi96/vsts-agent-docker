FROM janzi/vsts-build-agents:ubuntu-18.04-standard

ARG DOCKER_CHANNEL=stable
ARG DOCKER_VERSION=18.06.3-ce
ARG DOCKER_PLATFORM=x86_64
ARG DOCKER_COMPOSE_VERSION=1.25.0

RUN set -ex \
 && curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${DOCKER_PLATFORM}/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
 && tar --extract --file docker.tgz --strip-components 1 --directory /usr/local/bin \
 && rm docker.tgz \
 && docker -v

RUN set -x \
 && curl -fSL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m`" -o /usr/local/bin/docker-compose \
 && chmod +x /usr/local/bin/docker-compose \
 && docker-compose -v
