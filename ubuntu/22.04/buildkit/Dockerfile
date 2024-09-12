# docker build -t janzi/vsts-build-agents:ubuntu-22.04-standard-buildah buildah/.
FROM janzi/vsts-build-agents:ubuntu-22.04-standard

RUN curl -sL https://github.com/vmware-archive/buildkit-cli-for-kubectl/releases/download/v0.1.6/kubectl-buildkit_0.1.6_amd64.deb -o buildkit-cli-for-kubectl.deb \
   && dpkg -i ./buildkit-cli-for-kubectl.deb \
   && rm -f ./buildkit-cli-for-kubectl.deb
