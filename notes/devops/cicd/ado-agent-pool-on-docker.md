# Azure DevOps Agent Pool on Docker

This guide provides step-by-step instructions for running Azure DevOps self-hosted agents in Docker containers. Both Windows and Linux containers are supported.

## Prerequisites

- Docker installed on your system
- Azure DevOps organization or Azure DevOps Server instance
- Personal Access Token (PAT) with Agent Pools (read, manage) scope
- Basic understanding of Docker and Azure DevOps pipelines

## Overview

Running Azure DevOps agents in Docker containers provides:

- Consistent build environments
- Easy scaling and orchestration
- Isolation between builds
- Simplified agent management

## Windows Container Setup

### 1. Enable Hyper-V

Hyper-V must be enabled for container isolation:

- Ensure virtualization is enabled in BIOS/UEFI
- Enable Hyper-V feature in Windows
- Restart if required

### 2. Install Docker for Windows

- **Windows 10**: Install [Docker Community Edition](https://docs.docker.com/docker-for-windows/install)
- **Windows Server 2016**: Install [Docker Enterprise Edition](https://docs.docker.com/install/windows/docker-ee)

### 3. Switch to Windows Containers

Ensure Docker is configured to use Windows containers:

```bash
# Switch to Windows containers mode
docker system info
```

### 4. Create Windows Dockerfile

Create directory structure:

```cmd
mkdir "C:\azp-agent-in-docker\"
cd "C:\azp-agent-in-docker\"
```

Create `azp-agent-windows.dockerfile`:

```dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2022
WORKDIR /azp/
COPY ./start.ps1 ./
CMD powershell .\start.ps1
```

### 5. Create Windows Start Script

Create `start.ps1`:

```powershell
function Print-Header ($header) {
    Write-Host "`n${header}`n" -ForegroundColor Cyan
}

if (-not (Test-Path Env:AZP_URL)) {
    Write-Error "error: missing AZP_URL environment variable"
    exit 1
}

if (-not (Test-Path Env:AZP_TOKEN_FILE)) {
    if (-not (Test-Path Env:AZP_TOKEN)) {
        Write-Error "error: missing AZP_TOKEN environment variable"
        exit 1
    }
    $Env:AZP_TOKEN_FILE = "\azp\.token"
    $Env:AZP_TOKEN | Out-File -FilePath $Env:AZP_TOKEN_FILE
}

Remove-Item Env:AZP_TOKEN

if ((Test-Path Env:AZP_WORK) -and -not (Test-Path $Env:AZP_WORK)) {
    New-Item $Env:AZP_WORK -ItemType directory | Out-Null
}

New-Item "\azp\agent" -ItemType directory | Out-Null

# Let the agent ignore the token env variables
$Env:VSO_AGENT_IGNORE = "AZP_TOKEN,AZP_TOKEN_FILE"

Set-Location agent

Print-Header "1. Determining matching Azure Pipelines agent..."
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$(Get-Content ${Env:AZP_TOKEN_FILE})"))
$package = Invoke-RestMethod -Headers @{Authorization=("Basic $base64AuthInfo")} "$(${Env:AZP_URL})/_apis/distributedtask/packages/agent?platform=win-x64&`$top=1"
$packageUrl = $package[0].Value.downloadUrl
Write-Host $packageUrl

Print-Header "2. Downloading and installing Azure Pipelines agent..."
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($packageUrl, "$(Get-Location)\agent.zip")
Expand-Archive -Path "agent.zip" -DestinationPath "\azp\agent"

try {
    Print-Header "3. Configuring Azure Pipelines agent..."
    .\config.cmd --unattended `
        --agent "$(if (Test-Path Env:AZP_AGENT_NAME) { ${Env:AZP_AGENT_NAME} } else { hostname })" `
        --url "$(${Env:AZP_URL})" `
        --auth PAT `
        --token "$(Get-Content ${Env:AZP_TOKEN_FILE})" `
        --pool "$(if (Test-Path Env:AZP_POOL) { ${Env:AZP_POOL} } else { 'Default' })" `
        --work "$(if (Test-Path Env:AZP_WORK) { ${Env:AZP_WORK} } else { '_work' })" `
        --replace

    Print-Header "4. Running Azure Pipelines agent..."
    .\run.cmd
} finally {
    Print-Header "Cleanup. Removing Azure Pipelines agent..."
    .\config.cmd remove --unattended `
        --auth PAT `
        --token "$(Get-Content ${Env:AZP_TOKEN_FILE})"
}
```

### 6. Build Windows Image

```cmd
docker build --tag "azp-agent:windows" --file "./azp-agent-windows.dockerfile" .
```

### 7. Run Windows Container

```cmd
docker run -e AZP_URL="<Azure DevOps instance>" -e AZP_TOKEN="<Personal Access Token>" -e AZP_POOL="<Agent Pool Name>" -e AZP_AGENT_NAME="Docker Agent - Windows" --name "azp-agent-windows" azp-agent:windows
```

Additional options:

- Add `--network "Default Switch"` if you encounter network issues
- Add `--interactive --tty` (or `-it`) to stop with Ctrl+C
- Add `--once` flag for single-use containers

## Linux Container Setup

### 1. Install Docker

Install Docker based on your Linux distribution:

- **Ubuntu/Debian**: Follow [Docker CE installation guide](https://docs.docker.com/install/)
- **Enterprise**: Use [Docker EE](https://docs.docker.com/ee/supported-platforms/)

### 2. Create Linux Dockerfile

Create directory structure:

```bash
mkdir ~/azp-agent-in-docker/
cd ~/azp-agent-in-docker/
```

Create `azp-agent-linux.dockerfile`:

**For Alpine Linux:**

```dockerfile
FROM python:3-alpine
ENV TARGETARCH="linux-musl-x64"
# Another option:
# FROM arm64v8/alpine
# ENV TARGETARCH="linux-musl-arm64"

RUN apk update && \
    apk upgrade && \
    apk add bash curl gcc git icu-libs jq musl-dev python3-dev libffi-dev openssl-dev cargo make

# Install Azure CLI
RUN pip install --upgrade pip
RUN pip install azure-cli

WORKDIR /azp/
COPY ./start.sh ./
RUN chmod +x ./start.sh

RUN adduser -D agent
RUN chown agent ./
USER agent
# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT [ "./start.sh" ]
```

**For Ubuntu 22.04:**

```dockerfile
FROM ubuntu:22.04
ENV TARGETARCH="linux-x64"
# Also can be "linux-arm", "linux-arm64".

RUN apt update && \
    apt upgrade -y && \
    apt install -y curl git jq libicu70

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

WORKDIR /azp/
COPY ./start.sh ./
RUN chmod +x ./start.sh

# Create agent user and set up home directory
RUN useradd -m -d /home/agent agent
RUN chown -R agent:agent /azp /home/agent

USER agent
# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT [ "./start.sh" ]
```

> **Note**: Add additional packages as needed. For example, add `zip` and `unzip` for `ArchiveFiles` and `ExtractFiles` tasks.

### 3. Create Linux Start Script

Create `start.sh` with Unix-style (LF) line endings:

```bash
#!/bin/bash
set -e

if [ -z "${AZP_URL}" ]; then
    echo 1>&2 "error: missing AZP_URL environment variable"
    exit 1
fi

if [ -n "$AZP_CLIENTID" ]; then
    echo "Using service principal credentials to get token"
    az login --allow-no-subscriptions --service-principal --username "$AZP_CLIENTID" --password "$AZP_CLIENTSECRET" --tenant "$AZP_TENANTID"
    AZP_TOKEN=$(az account get-access-token --query accessToken --output tsv)
    echo "Token retrieved"
fi

if [ -z "${AZP_TOKEN_FILE}" ]; then
    if [ -z "${AZP_TOKEN}" ]; then
        echo 1>&2 "error: missing AZP_TOKEN environment variable"
        exit 1
    fi
    AZP_TOKEN_FILE="/azp/.token"
    echo -n "${AZP_TOKEN}" > "${AZP_TOKEN_FILE}"
fi

unset AZP_CLIENTSECRET
unset AZP_TOKEN

if [ -n "${AZP_WORK}" ]; then
    mkdir -p "${AZP_WORK}"
fi

cleanup() {
    trap "" EXIT
    if [ -e ./config.sh ]; then
        print_header "Cleanup. Removing Azure Pipelines agent..."
        # If the agent has some running jobs, the configuration removal process will fail.
        # So, give it some time to finish the job.
        while true; do
            ./config.sh remove --unattended --auth "PAT" --token $(cat "${AZP_TOKEN_FILE}") && break
            echo "Retrying in 30 seconds..."
            sleep 30
        done
    fi
}

print_header() {
    lightcyan="\033[1;36m"
    nocolor="\033[0m"
    echo -e "\n${lightcyan}$1${nocolor}\n"
}

# Let the agent ignore the token env variables
export VSO_AGENT_IGNORE="AZP_TOKEN,AZP_TOKEN_FILE"

print_header "1. Determining matching Azure Pipelines agent..."
AZP_AGENT_PACKAGES=$(curl -LsS \
    -u user:$(cat "${AZP_TOKEN_FILE}") \
    -H "Accept:application/json" \
    "${AZP_URL}/_apis/distributedtask/packages/agent?platform=${TARGETARCH}&top=1")

AZP_AGENT_PACKAGE_LATEST_URL=$(echo "${AZP_AGENT_PACKAGES}" | jq -r ".value[0].downloadUrl")

if [ -z "${AZP_AGENT_PACKAGE_LATEST_URL}" -o "${AZP_AGENT_PACKAGE_LATEST_URL}" == "null" ]; then
    echo 1>&2 "error: could not determine a matching Azure Pipelines agent"
    echo 1>&2 "check that account \"${AZP_URL}\" is correct and the token is valid for that account"
    exit 1
fi

print_header "2. Downloading and extracting Azure Pipelines agent..."
curl -LsS "${AZP_AGENT_PACKAGE_LATEST_URL}" | tar -xz & wait $!

source ./env.sh

trap "cleanup; exit 0" EXIT
trap "cleanup; exit 130" INT
trap "cleanup; exit 143" TERM

print_header "3. Configuring Azure Pipelines agent..."
./config.sh --unattended \
    --agent "${AZP_AGENT_NAME:-$(hostname)}" \
    --url "${AZP_URL}" \
    --auth "PAT" \
    --token $(cat "${AZP_TOKEN_FILE}") \
    --pool "${AZP_POOL:-Default}" \
    --work "${AZP_WORK:-_work}" \
    --replace \
    --acceptTeeEula & wait $!

print_header "4. Running Azure Pipelines agent..."
chmod +x ./run.sh
./run.sh "$@" & wait $!
```

### 4. Build Linux Image

```bash
docker build --tag "azp-agent:linux" --file "./azp-agent-linux.dockerfile" .
```

### 5. Run Linux Container

```bash
docker run -e AZP_URL="<Azure DevOps instance>" -e AZP_TOKEN="<Personal Access Token>" -e AZP_POOL="<Agent Pool Name>" -e AZP_AGENT_NAME="Docker Agent - Linux" --name "azp-agent-linux" azp-agent:linux
```

Additional options:

- Add `--interactive --tty` (or `-it`) to stop with Ctrl+C
- Add `--once` flag for single-use containers

## Environment Variables

| Variable           | Description                             | Default            |
| ------------------ | --------------------------------------- | ------------------ |
| `AZP_URL`          | Azure DevOps or Azure DevOps Server URL | Required           |
| `AZP_TOKEN`        | Personal Access Token                   | Required\*         |
| `AZP_CLIENTID`     | Service principal client ID             | Required\*         |
| `AZP_CLIENTSECRET` | Service principal client secret         | Required\*         |
| `AZP_TENANTID`     | Service principal tenant ID             | Required\*         |
| `AZP_AGENT_NAME`   | Agent name                              | Container hostname |
| `AZP_POOL`         | Agent pool name                         | `Default`          |
| `AZP_WORK`         | Work directory                          | `_work`            |

\*Either `AZP_TOKEN` or service principal credentials (`AZP_CLIENTID`, `AZP_CLIENTSECRET`, `AZP_TENANTID`) are required.

## Authentication & Authorization

### Personal Access Token (PAT)

- Create PAT with **Agent Pools (read, manage)** scope
- Must be created by user with agent configuration permissions

### Service Principal

- Create service principal with appropriate permissions
- Use `AZP_CLIENTID`, `AZP_CLIENTSECRET`, and `AZP_TENANTID` instead of PAT

## Container Customization

### Adding Tools and Dependencies

Extend the Dockerfile to include additional tools:

```dockerfile
# Add to Ubuntu Dockerfile
RUN apt install -y \
    zip unzip \
    python3 python3-pip \
    nodejs npm \
    dotnet-sdk-6.0
```

### Important Notes

- Keep the `start.sh` script untouched
- Ensure all required tools are in the container's `PATH`
- Consider security implications when adding tools

## Advanced Usage

### Docker-in-Docker (DinD)

To use Docker within the container:

```bash
docker run \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e AZP_URL="<URL>" \
    -e AZP_TOKEN="<TOKEN>" \
    azp-agent:linux
```

⚠️ **Security Warning**: This gives the container root access to the Docker host.

### Single-Use Containers

Use `--once` flag for containers that run one job and exit:

```bash
docker run --once \
    -e AZP_URL="<URL>" \
    -e AZP_TOKEN="<TOKEN>" \
    azp-agent:linux
```

### Custom MTU Settings

Set custom MTU for container networks:

```bash
docker run \
    -e AGENT_DOCKER_MTU_VALUE=1450 \
    -e AZP_URL="<URL>" \
    -e AZP_TOKEN="<TOKEN>" \
    azp-agent:linux
```

## Kubernetes Deployment

### Prerequisites

- Azure Kubernetes Service (AKS) cluster
- Azure Container Registry (ACR)
- kubectl configured

### Create Secrets

```bash
kubectl create secret generic azdevops \
    --from-literal=AZP_URL=https://dev.azure.com/yourOrg \
    --from-literal=AZP_TOKEN=YourPAT \
    --from-literal=AZP_POOL=NameOfYourPool
```

### Push Image to ACR

```bash
docker push "<acr-server>/azp-agent:<tag>"
```

### Configure ACR Integration

```bash
az aks update -n "<myAKSCluster>" -g "<myResourceGroup>" --attach-acr "<acr-name>"
```

### Deploy to Kubernetes

Create `ReplicationController.yml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: azdevops-deployment
  labels:
    app: azdevops-agent
spec:
  replicas: 1
  selector:
    matchLabels:
      app: azdevops-agent
  template:
    metadata:
      labels:
        app: azdevops-agent
    spec:
      containers:
        - name: kubepodcreation
          image: <acr-server>/azp-agent:<tag>
          env:
            - name: AZP_URL
              valueFrom:
                secretKeyRef:
                  name: azdevops
                  key: AZP_URL
            - name: AZP_TOKEN
              valueFrom:
                secretKeyRef:
                  name: azdevops
                  key: AZP_TOKEN
            - name: AZP_POOL
              valueFrom:
                secretKeyRef:
                  name: azdevops
                  key: AZP_POOL
          volumeMounts:
            - mountPath: /var/run/docker.sock
              name: docker-volume
      volumes:
        - name: docker-volume
          hostPath:
            path: /var/run/docker.sock
```

Deploy:

```bash
kubectl apply -f ReplicationController.yml
```

## Troubleshooting

### Common Issues

1. **"no such file or directory" error on Windows**

   - Install Git Bash
   - Convert line endings: `dos2unix start.sh`

2. **Agent not connecting**

   - Verify `AZP_URL` and `AZP_TOKEN`
   - Check network connectivity
   - Ensure PAT has correct permissions

3. **Docker-in-Docker not working**
   - Verify Docker socket mount
   - Check container permissions
   - Consider security implications

### Volume Mounting in DinD

When using Docker-in-Docker, mount paths reference the host:

```bash
# Mount from host to outer container
docker run -v "<path-on-host>:<path-on-outer-container>" ...

# Mount from host to inner container
docker run -v "<path-on-host>:<path-on-inner-container>" ...

# Use environment variable for outer-to-inner mounting
docker run --env DIND_USER_HOME=$HOME ...
# Then in inner container:
docker run -v "${DIND_USER_HOME}:<path-on-inner-container>" ...
```

## Best Practices

1. **Security**

   - Use least privilege principles
   - Regularly rotate PATs
   - Avoid running as root when possible
   - Monitor container access

2. **Performance**

   - Use multi-stage builds for smaller images
   - Cache dependencies appropriately
   - Consider using `--once` for ephemeral workloads

3. **Monitoring**

   - Implement health checks
   - Monitor resource usage
   - Set up logging and alerting

4. **Maintenance**
   - Keep base images updated
   - Regular security scanning
   - Automate image builds and deployments

## Resources

- [Azure DevOps Self-hosted Agents](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/agents)
- [Docker Documentation](https://docs.docker.com/)
- [Azure Container Registry](https://docs.microsoft.com/en-us/azure/container-registry/)
- [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/)

