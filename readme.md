# Azure Pipeline Agent 

## Run

````shell
docker run -e AZP_URL=<Azure DevOps instance> -e AZP_TOKEN=<PAT token> -e AZP_AGENT_NAME=mydockeragent lapierre/azure-agent:latest
````

## Environment variables

AZP_URL - required, user PAT token from 
AZP_TOKEN - required, Azure DevOps organization url
AZP_POOL - pool name (or Default if not set)
AZP_WORK - work dir (or /_work if not set)
AZP_AGENT_NAME - agent name (or hostname if not set)
DEPLOYMENT - if is set, container will run in specified deployment pool name 
