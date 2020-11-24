# docker build -t janzi/vsts-build-agents:ubuntu-20.04-standard standard/.

FROM janzi/vsts-build-agents:ubuntu-20.04

ARG GO_VERSION=1.13.5
ARG CMAKE_MINOT_VERSION=3.16
ARG CMAKE_VERSION=${CMAKE_MINOT_VERSION}.0
ARG GRADLE_VERISON=6.0
ARG PY2_VERSION=2.7-v7.3.3
ARG PY3_VERSION=3.6-v7.3.3

# Install basic command-line utilities
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    curl \
    dnsutils \
    file \
    ftp \
    iproute2 \
    iputils-ping \
    locales \
    openssh-client \
    rsync\
    shellcheck \
    sudo \
    telnet \
    time \
    unzip \
    wget \
    zip \
    tzdata \
    apt-transport-https \
    lsb-release \
    gnupg \
 && rm -rf /var/lib/apt/lists/*

# Enable detection of running in a container
ENV DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip
# For us it runs longer, so no need to drop it
# ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true

# Setup the locale
ENV LANG=en_US.UTF-8 \
    LC_ALL=$LANG \
    # Accept EULA - needed for certain Microsoft packages like SQL Server Client Tools
    ACCEPT_EULA=Y

RUN locale-gen $LANG \
 && update-locale


# Install essential build tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

# Install Ansible
RUN apt-get update \   
 && apt-get install -y --no-install-recommends \
    ansible \      
 && rm -rf /var/lib/apt/lists/*

# Install Azure CLI (instructions taken from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" \
  | tee /etc/apt/sources.list.d/azure-cli.list \
 && curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    apt-transport-https \
    azure-cli \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/* \
 && az --version

# Install CMake
RUN curl -sL https://cmake.org/files/v${CMAKE_MINOT_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh -o cmake.sh \
 && chmod +x cmake.sh \
 && ./cmake.sh --prefix=/usr/local --exclude-subdir \
 && rm cmake.sh

# Install Go
#RUN curl -sL https://dl.google.com/go/go1.9.4.linux-amd64.tar.gz -o go1.9.4.linux-amd64.tar.gz \
# && mkdir -p /usr/local/go1.9.4 \
# && tar -C /usr/local/go1.9.4 -xzf go1.9.4.linux-amd64.tar.gz --strip-components=1 go \
# && rm go1.9.4.linux-amd64.tar.gz
RUN curl -sL https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz -o go${GO_VERSION}.linux-amd64.tar.gz \
 && mkdir -p /usr/local/go${GO_VERSION} \
 && tar -C /usr/local/go${GO_VERSION} -xzf go${GO_VERSION}.linux-amd64.tar.gz --strip-components=1 go \
 && rm go${GO_VERSION}.linux-amd64.tar.gz
ENV GOROOT_1_12_X64=/usr/local/go${GO_VERSION} \
    GOROOT=/usr/local/go${GO_VERSION}
#GOROOT_1_9_X64=/usr/local/go1.9.4 \
ENV PATH $PATH:$GOROOT/bin

# Install Helm
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get-helm-3 | bash

# Install Heroku CLI
RUN curl https://cli-assets.heroku.com/install.sh | sh

# Install ImageMagick
RUN apt-get update \
 && apt-get install -y --no-install-recommends --fix-missing \
    imagemagick \
    libmagickcore-dev \
    libmagickwand-dev \
    libmagic-dev \
 && rm -rf /var/lib/apt/lists/*

# Install Java zulujdk
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 \
   && apt-add-repository 'deb http://repos.azulsystems.com/ubuntu stable main' \
   && apt-get update \
   && apt-get install -y --no-install-recommends zulu-8 \
   && apt-get install -y --no-install-recommends zulu-11 \
   && apt-get install -y --no-install-recommends zulu-14 \
   && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME_8_X64=/usr/lib/jvm/zulu-8-jdk-amd64 \
    JAVA_HOME_11_X64=/usr/lib/jvm/zulu-11-amd64 \
    JAVA_HOME_14_X64=/usr/lib/jvm/zulu-14-amd64 \
    JAVA_HOME=/usr/lib/jvm/zulu11jdk-amd64 \
    JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8

# Install Java Tools (Ant, Gradle, Maven)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ant \
    ant-optional \
 && rm -rf /var/lib/apt/lists/*
RUN curl -sL https://services.gradle.org/distributions/gradle-${GRADLE_VERISON}-bin.zip -o gradle-${GRADLE_VERISON}.zip \
 && unzip -d /usr/share gradle-${GRADLE_VERISON}.zip \
 && ln -s /usr/share/gradle-6.0/bin/gradle /usr/bin/gradle \
 && rm gradle-${GRADLE_VERISON}.zip
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    maven \
 && rm -rf /var/lib/apt/lists/*
ENV ANT_HOME=/usr/share/ant \
    GRADLE_HOME=/usr/share/gradle \
    M2_HOME=/usr/share/maven

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
 && chmod +x ./kubectl \
 && mv ./kubectl /usr/local/bin/kubectl

# Install Miniconda
RUN curl -sL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda.sh \
 && chmod +x miniconda.sh \
 && ./miniconda.sh -b -p /usr/share/miniconda \
 && rm miniconda.sh
ENV CONDA=/usr/share/miniconda

# # Install Mono
# RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
#  && echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
#  && apt-get update \
#  && apt-get install -y --no-install-recommends apt-transport-https mono-complete \
#  && rm -rf /var/lib/apt/lists/* \
#  && rm -rf /etc/apt/sources.list.d/*

# Install MS SQL Server client tools (https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-2017)
RUN [ "xenial" = "xenial" ] \
  && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/msprod.list \
  && apt-get update \
  && apt-get install -y mssql-tools unixodbc-dev \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /etc/apt/sources.list.d/* \
  || echo -n
ENV PATH=$PATH:/opt/mssql-tools/bin

# Install MySQL Client
RUN apt-get update \
  && apt-get install -y mysql-client \
  && rm -rf /var/lib/apt/lists/*
ENV mysql=/usr/bin/mysql

# Install MySQL Server
ENV MYSQL_ROOT_PASSWORD=
RUN bash -c 'debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"'
RUN bash -c 'debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"'
RUN apt-get update \
  && apt-get install -y mysql-server \
  && rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK and initialize package cache
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb > packages-microsoft-prod.deb \
 && dpkg -i packages-microsoft-prod.deb \
 && rm packages-microsoft-prod.deb \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    apt-transport-https \
    dotnet-sdk-2.1 \
    dotnet-sdk-3.1 \
    dotnet-sdk-5.0 \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*
# RUN dotnet help
ENV dotnet=/usr/bin/dotnet \
    DOTNET_CLI_TELEMETRY_OPTOUT=1

# Install AzCopy (depends on .NET Core)
# RUN apt-key adv --keyserver packages.microsoft.com --recv-keys EB3E94ADBE1229CF \
#  && echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod/ xenial main" | tee /etc/apt/sources.list.d/azure.list \
#  && apt-get update \
#  && apt-get install -y --no-install-recommends azcopy \
#  && rm -rf /var/lib/apt/lists/* \
#  && rm -rf /etc/apt/sources.list.d/*
RUN wget https://aka.ms/downloadazcopy-v10-linux \
   && tar -xvf downloadazcopy-v10-linux --strip-components=1  \
   && mv ./azcopy /usr/bin/ \
   && rm -rf downloadazcopy-v10-linux \
ENV PATH="/usr/bin:${PATH}"

#Expand Archive
#(Optional) Remove existing AzCopy version
#Move AzCopy to the destination you want to store it

# Install LTS Node.js and related tools
RUN curl -sL https://git.io/n-install | bash -s -- -ny - \
 && ~/n/bin/n lts \
 && npm install -g bower \
 && npm install -g grunt \
 && npm install -g gulp \
 && npm install -g n \
 && npm install -g webpack webpack-cli --save-dev \
 && npm install -g parcel-bundler \
 && npm i -g npm \
 && rm -rf ~/n
ENV bower=/usr/local/bin/bower \
    grunt=/usr/local/bin/grunt

# # Install PhantomJS
# RUN apt-get update \
#  && apt-get install -y chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev \
#  && rm -rf /var/lib/apt/lists/* \
#  && export PHANTOM_JS=phantomjs-2.1.1-linux-x86_64 \
#  && wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 \
#  && tar xvjf $PHANTOM_JS.tar.bz2 \
#  && mv $PHANTOM_JS /usr/local/share \
#  && ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin

# # Install Pollinate
# RUN apt-get update \
#  && apt-get install -y --no-install-recommends pollinate \
#  && rm -rf /var/lib/apt/lists/*

# Install Powershell Core
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    powershell \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*

# Instally PyPy2
RUN curl https://downloads.python.org/pypy/pypy${PY2_VERSION}-linux64.tar.bz2 --output /tmp/pypy${PY2_VERSION}-linux64.tar.bz2 \
   && tar -x -C /opt -f /tmp/pypy${PY2_VERSION}-linux64.tar.bz2 \
   && rm /tmp/pypy${PY2_VERSION}-linux64.tar.bz2 \
   && mv /opt/pypy${PY2_VERSION}-linux64 /opt/pypy2 \
   && ln -s /opt/pypy2/bin/pypy /usr/local/bin/py

# Install PyPy3
RUN curl https://downloads.python.org/pypy/pypy${PY3_VERSION}-linux64.tar.bz2 --output /tmp/pypy${PY3_VERSION}-linux64.tar.bz2 \
 && tar -x -C /opt -f /tmp/pypy${PY3_VERSION}-linux64.tar.bz2 \
 && rm /tmp/pypy${PY3_VERSION}-linux64.tar.bz2 \
 && mv /opt/pypy${PY3_VERSION}-linux64 /opt/pypy3 \
 && ln -s /opt/pypy3/bin/pypy3 /usr/local/bin/pypy3

# Install Python
RUN sudo add-apt-repository universe \
   && apt-get update \
 && apt-get install -y --no-install-recommends \
    python \
    python2 \
    python3 \
    python3-pip \
 && rm -rf /var/lib/apt/lists/* \
 && curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py \
 && python2 get-pip.py

# Install Scala build tools
RUN curl -s https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt > /usr/local/bin/sbt \
 && chmod 0755 /usr/local/bin/sbt

# Install Terraform
RUN TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version) \
 && curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
 && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
 && rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# XSLT transformation
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    xsltproc \
    xalan \
 && rm -rf /var/lib/apt/lists/*

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends yarn \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*

# Install Xvfb
RUN apt-get update \
 && apt-get install -y xvfb \
 && rm -rf /var/lib/apt/lists/*

# Clean system
RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*
