# Azure Pipeline Agent 

Azure DevOps Pipeline agent base on `lapierre/linux-admin` and https://docs.microsoft.com/pl-pl/azure/devops/pipelines/agents/docker?view=azure-devops

## Run

````shell
docker run -e AZP_URL=<Azure DevOps instance> -e AZP_TOKEN=<PAT token> -e AZP_AGENT_NAME=mydockeragent lapierre/azure-agent:latest
````

## Environment variables

- `AZP_URL` - required, Azure DevOps organization url 
- `AZP_TOKEN` - required, user PAT token (https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/linux-agent?view=azure-devops)
- `AZP_POOL` - pool name (or Default if not set)
- `AZP_WORK` - work dir (or /_work if not set)
- `AZP_AGENT_NAME` - agent name (or hostname if not set)
- `DEPLOYMENT` - if is set, container will run in specified deployment pool name 

## Run on Docker Swarm

````shell
echo "PAT_token" | docker secret create azure-agent -
````

````yaml
version: "3.9"

services:
  agent:
    image: lapierre/azure-agent:0.0.10
    environment:
      - AZP_AGENT_NAME=...
      - AZP_POOL=...
      - DEPLOYMENT_TYPE=DEV
      - AZP_TOKEN_FILE=/run/secrets/azure-agent
      - AZP_URL=https://dev.azure.com/..../
    secrets:
      - azure-agent
    volumes:
      - agent:/_work
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/bin/docker:/usr/bin/docker

volumes:
  agent:

secrets:
  azure-agent:
    external: true
````
