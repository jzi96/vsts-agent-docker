# docker build -t janzi/vsts-build-agents:ubuntu-22.04-standard-buildah buildah/.
FROM janzi/vsts-build-agents:ubuntu-22.04-standard

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    buildah \
 && rm -rf /var/lib/apt/lists/*
