# fork VSTS-Build-Agents

Forked the VSTS Build Agents [Azure Pipelines Agent](https://hub.docker.com/_/microsoft-azure-pipelines-vsts-agent)

You may be looking for the Azure Pipelines hosted images, which are generated in the [azure-pipelines-image-generation](https://github.com/Microsoft/azure-pipelines-image-generation) repo.

![](https://github.com/jzi96/vsts-agent-docker/raw/master/images/vsts.png)

## Build status

|Version  |Build Status  |
|---------|---------|
|Ubuntu 16.04     | [![Build Status](https://zieschang.visualstudio.com/vsts-buid-agents/_apis/build/status/16.04/vsts.16.04?branchName=master)](https://zieschang.visualstudio.com/vsts-buid-agents/_build/latest?definitionId=6&branchName=master) |
|Ubuntu 16.04 Standard | [![Build Status ](https://zieschang.visualstudio.com/vsts-buid-agents/_apis/build/status/16.04/vsts.standard-16.04?branchName=master)](https://zieschang.visualstudio.com/vsts-buid-agents/_build/latest?definitionId=8&branchName=master) |
|Ubuntu 16.04 Docker Standard     | [![Build Status](https://zieschang.visualstudio.com/vsts-buid-agents/_apis/build/status/16.04/vsts.docker-standard-16.04?branchName=master)](https://zieschang.visualstudio.com/vsts-buid-agents/_build/latest?definitionId=9&branchName=master) |
|Ubuntu 18.04     | [![Build Status](https://zieschang.visualstudio.com/vsts-buid-agents/_apis/build/status/18.04/vsts.18.04?branchName=master)](https://zieschang.visualstudio.com/vsts-buid-agents/_build/latest?definitionId=12&branchName=master) |
|Ubuntu 18.04 Standard     | [![Build Status](https://zieschang.visualstudio.com/vsts-buid-agents/_apis/build/status/18.04/vsts.standard-18.04?branchName=master)](https://zieschang.visualstudio.com/vsts-buid-agents/_build/latest?definitionId=11&branchName=master) |
|Ubuntu 18.04 Docker Standard     |  [![Build Status](https://zieschang.visualstudio.com/vsts-buid-agents/_apis/build/status/18.04/vsts.docker-standard-18.04?branchName=master)](https://zieschang.visualstudio.com/vsts-buid-agents/_build/latest?definitionId=10&branchName=master) |

## Visual Studio Team Services agent

This repository contains images for the Visual Studio Team Services (VSTS) agent that runs tasks as part of a build or release.

## Supported tags and `Dockerfile` links

VSTS agent images are tagged according to the base OS, an optional Team Foundation Server (TFS) version, and tools that are installed:

- [`ubuntu-16.04`](https://github.com/jzi96/vsts-agent-docker/blob/master/ubuntu/16.04/Dockerfile) [(ubuntu/16.04/Dockerfile)](https://github.com/jzi96/vsts-agent-docker/blob/master/ubuntu/16.04/Dockerfile)
- [`ubuntu-16.04-standard`](https://github.com/jzi96/vsts-agent-docker/blob/master/ubuntu/16.04/standard/Dockerfile) [(ubuntu/16.04/standard/Dockerfile)](https://github.com/jzi96/vsts-agent-docker/blob/master/ubuntu/16.04/standard/Dockerfile)
- [`ubuntu-16.04-docker-standard`](https://github.com/jzi96/vsts-agent-docker/blob/master/ubuntu/16.04/docker/18.06.1-ce/standard/Dockerfile), [`latest`](https://github.com/jzi96/vsts-agent-docker/blob/master/ubuntu/16.04/docker/18.06.1-ce/standard/Dockerfile) [(ubuntu/16.04/docker/18.06.1-ce/standard/Dockerfile)](https://github.com/jzi96/vsts-agent-docker/blob/master/ubuntu/16.04/docker/18.06.1-ce/standard/Dockerfile)

- [`ubuntu-18.04`](https://github.com/jzi96/vsts-agent-docker/blob/master/ubuntu/18.04/Dockerfile) [(ubuntu/18.04/Dockerfile)](https://github.com/jzi96/vsts-agent-docker/blob/master/ubuntu/18.04/Dockerfile)
- [`ubuntu-18.04-standard`](https://github.com/jzi96/vsts-agent-docker/blob/master/ubuntu/18.04/standard/Dockerfile) [(ubuntu/18.04/standard/Dockerfile)](https://github.com/jzi96/vsts-agent-docker/blob/master/ubuntu/18.04/standard/Dockerfile)
- [`ubuntu-18.04-docker-standard`](https://github.com/jzi96/vsts-agent-docker/blob/master/ubuntu/18.04/docker/18.06.1-ce/standard/Dockerfile), [`latest`](https://github.com/jzi96/vsts-agent-docker/blob/master/ubuntu/18.04/docker/18.06.1-ce/standard/Dockerfile) [(ubuntu/18.04/docker/18.06.1-ce/standard/Dockerfile)](https://github.com/jzi96/vsts-agent-docker/blob/master/ubuntu/18.04/docker/18.06.1-ce/standard/Dockerfile)


Ubuntu 18.04 and 16.04 are the currently supported OSes, but there are plans for Windows support.

When used with VSTS, the agent version is automatically determined and downloaded at container startup based on the account to which the agent is connecting. When used with TFS, an image that matches the installed TFS version should be chosen.

Derived images that are based on the standalone agent images provide a variety of capabilities that enable it to support specific VSTS build and release tasks.

The `latest` tag always points at a standard image based on the best supported OS that targets VSTS and includes capabilities enabling many of the built-in VSTS build and release tasks.

## How to use these images
VSTS agents must be started with account connection information, which is provided through two environment variables:

- `VSTS_ACCOUNT`: the name of the Visual Studio account
- `VSTS_TOKEN`: a personal access token (PAT) for the Visual Studio account that has been given at least the **Agent Pools (read, manage)** scope.

To run the default VSTS agent image for a specific Visual Studio account:

```
docker run \
  -e VSTS_ACCOUNT=<name> \
  -e VSTS_TOKEN=<pat> \
  -it microsoft/vsts-agent
```

When using an image that targets a specific TFS version, the connection information is instead supplied through one of the following environment variables:

- `TFS_HOST`: the hostname of the Team Foundation Server
- `TFS_URL`: the full URL of the Team Foundation Server
- `VSTS_TOKEN`: a personal access token (PAT) for the Team Foundation Server account that has been given at least the **Agent Pools (read, manage)** scope.

If `TFS_HOST` is provided, the TFS URL is set to `https://$TFS_HOST/tfs`. If `TFS_URL` is provided, any `TFS_HOST` environment variable is ignored.

To run a VSTS agent image for TFS 2018 that identifies the server at `https://mytfs/tfs`:

```
docker run \
  -e TFS_HOST=mytfs \
  -e VSTS_TOKEN=<pat> \
  -it microsoft/vsts-agent:ubuntu-16.04-tfs-2018
```

A more secure option for passing the personal access token is supported by mounting a file that contains the token into the container and specifying the location of this file with the `VSTS_TOKEN_FILE` environment variable. For instance:

```
docker run \
  -v /path/to/my/token:/vsts-token \
  -e VSTS_ACCOUNT=<name> \
  -e VSTS_TOKEN_FILE=/vsts-token \
  -it microsoft/vsts-agent
```

Whether targeting VSTS or TFS, agents can be further configured with additional environment variables:

- `VSTS_AGENT`: the name of the agent (default: `"$(hostname)"`)
- `VSTS_POOL`: the name of the agent pool (default: `"Default"`)
- `VSTS_WORK`: the agent work folder (default: `"_work"`)

The `VSTS_AGENT` and `VSTS_WORK` values are evaluated inside the container as an expression so they can use shell expansions. The `VSTS_AGENT` value is evaluated first, so the `VSTS_WORK` value may reference the expanded `VSTS_AGENT` value.

To run a VSTS agent on Ubuntu 16.04 for a specific account with a custom agent name, pool and a volume mapped agent work folder:

```
docker run \
  -e VSTS_ACCOUNT=<name> \
  -e VSTS_TOKEN=<pat> \
  -e VSTS_AGENT='$(hostname)-agent' \
  -e VSTS_POOL=mypool \
  -e VSTS_WORK='/var/vsts/$VSTS_AGENT' \
  -v /var/vsts:/var/vsts \
  -it microsoft/vsts-agent:ubuntu-16.04
```

## Derived Images

### `standard` images
These derived images include a set of standard capabilities that enable many of the built-in VSTS build and release tasks. The Ubuntu-based standard images currently include:

- Basic command-line utilities (curl, ftp, etc.)
- Essential build tools (gcc, make, etc.)
- Ansible 2.6.3
- Azure CLI 2.0.38
- CMake 3.16.0
- GCC 5.4.0
- Go 1.13.5
- Helm master)
- Heroku CLI 7.7.10
- ImageMagick 6.8.9-9
- Java OpenJDK 8, 11 and 13 (ubuntu 18, 16) 14 on unbuntu 20
- Java tools (Ant 1.9.6, Gradle 6.0, Maven 3.3.9)
- jq 1.5-1
- kubectl (latest stable)
- Miniconda 4.5.4
- ImageMagick
- Mono 5.14.0.177
- Microsoft SQL Server Client Tools 17.2.0.1
- MySQL Client 5.7.23
- MySQL Server 5.7.23
- .NET Core SDK 2.1
- .NET Core SDK 3.1
- .NET Core SDK 5.0
- Node.js 8.11.3 LTS (with bower, grunt, gulp, n, parcel, and webpack)
- Powershell Core v6.1.0-preview.2
- PyPy2 (7.3.2) and PyPy3 (7.3.2)
- Python 2.7.15, 3.4.8, 3.5.5, 3.6.5 and 3.7.0 (available through the [Use Python Version](https://go.microsoft.com/fwlink/?linkid=871498) task)
- rsync 3.1.1
- Scala sbt-extras
- ShellCheck 0.3.7-5
- Terraform 0.11.8
- xsltproc 1.1.28 and xalan 1.11
- yarn 1.9.2

### `docker` images
These derived images include a version of the Docker CLI and a compatible version of the Docker Compose CLI. This image cannot run most of the built-in VSTS build or release tasks but it can run tasks that invoke arbitrary Docker workloads.

These images do not run "Docker in Docker", but rather re-use the host instance of Docker. To ensure this works correctly, volume map the host's Docker socket into the container:

```cmd
docker run \
  -e VSTS_ACCOUNT=<name> \
  -e VSTS_TOKEN=<pat> \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -it microsoft/vsts-agent:ubuntu-16.04-docker-17.12.0-ce
```

### `docker-standard` images
These derived images bring together a docker image and a standard image.

## How to Use this Image

VSTS agents must be started with account connection information, which is provided through two environment variables:

`VSTS_ACCOUNT`: the name of the Visual Studio account
`VSTS_TOKEN`: a personal access token (PAT) for the Visual Studio account that has been given at least the Agent Pools (read, manage) scope.
To run the default VSTS agent image for a specific Visual Studio account:

```cmd
docker run \
  -e VSTS_ACCOUNT=<name> \
  -e VSTS_TOKEN=<pat> \
  -it mcr.microsoft.com/azure-pipelines/vsts-agent
```

When using an image that targets a specific TFS version, the connection information is instead supplied through one of the following environment variables:

`TFS_HOST`: the hostname of the Team Foundation Server
`TFS_URL`: the full URL of the Team Foundation Server
`VSTS_TOKEN`: a personal access token (PAT) for the Team Foundation Server account that has been given at least the Agent Pools (read, manage) scope.
If `TFS_HOST` is provided, the TFS URL is set to https://$TFS_HOST/tfs. If TFS_URL is provided, any `TFS_HOST` environment variable is ignored.

To run a VSTS agent image for TFS 2018 that identifies the server at https://mytfs/tfs:

```cmd
docker run \
  -e TFS_HOST=mytfs \
  -e VSTS_TOKEN=<pat> \
  -it mcr.microsoft.com/azure-pipelines/vsts-agent:ubuntu-16.04-tfs-2018
```

A more secure option for passing the personal access token is supported by mounting a file that contains the token into the container and specifying the location of this file with the `VSTS_TOKEN_FILE` environment variable. For instance:

```cmd
docker run \
  -v /path/to/my/token:/vsts-token \
  -e VSTS_ACCOUNT=<name> \
  -e VSTS_TOKEN_FILE=/vsts-token \
  -it mcr.microsoft.com/azure-pipelines/vsts-agent
```

Whether targeting VSTS or TFS, agents can be further configured with additional environment variables:

`VSTS_AGENT`: the name of the agent (default: `"$(hostname)"`)
`VSTS_POOL`: the name of the agent pool (default: `"Default"`)
`VSTS_WORK`: the agent work folder (default: `"_work"`)
The `VSTS_AGENT` and `VSTS_WORK` values are evaluated inside the container as an expression so they can use shell expansions. The `VSTS_AGENT` value is evaluated first, so the `VSTS_WORK` value may reference the expanded `VSTS_AGENT` value.

To run a VSTS agent on Ubuntu 16.04 for a specific account with a custom agent name, pool and a volume mapped agent work folder:

```cmd
docker run \
  -e VSTS_ACCOUNT=<name> \
  -e VSTS_TOKEN=<pat> \
  -e VSTS_AGENT='$(hostname)-agent' \
  -e VSTS_POOL=mypool \
  -e VSTS_WORK='/var/vsts/$VSTS_AGENT' \
  -v /var/vsts:/var/vsts \
  -it mcr.microsoft.com/azure-pipelines/vsts-agent:ubuntu-16.04
```

These images do not run "Docker in Docker", but rather re-use the host instance of Docker. To ensure this works correctly, volume map the host's Docker socket into the container:

```cmd
docker run \
  -e VSTS_ACCOUNT=<name> \
  -e VSTS_TOKEN=<pat> \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -it mcr.microsoft.com/azure-pipelines/vsts-agent:ubuntu-16.04-docker-17.12.0-ce
```

## Kubenetes Deployment

Here is a sample yaml to deploy the container. You need to prepare the secret for the container.

1. Configure the secret
```cmd
kubectl create secret vsts
kubectl create secret generic vsts --from-literal=VSTS_TOKEN=<PAT> --from-literal=VSTS_ACCOUNT=<my-account>
```
2. Deploy the controller and container by running `kubectl create -f <pathtoyaml>` command. The yaml is in [Github repo](https://github.com/jzi96/vsts-agent-docker/blob/master/kubernetes/deployment.yaml).
