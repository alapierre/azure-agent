#!/bin/bash

set -e

pwd

print_error() {
  red='\033[0;31m'
  nocolor='\033[0m'
  echo -e "\n${red}$1${nocolor}"
}

#######################################
# Rollout deployment if config map changes#
# ARGUMENTS:
#   result from config map kubectl apply
#   result from application kubectl apply
#   deployment name to rollout (without deployment/)
# OUTPUTS:
#   nothing
# RETURN:
#   0 if succeeds, non-zero on error.
#######################################
reload_deployment_if_needed() {
  if [[ "$1" = *"configured" ]] && [[ "$2" = *"unchanged" ]]; then
    echo "config map changed, reloading deployment deployment/$3"
    kubectl rollout restart deployment/"$3"
  fi
}

#######################################
# Rollout deployment if config map changes
# GLOBALS:
# DEPLOYMENT_TYPE environment variable
#
# ARGUMENTS:
#   config map yaml file name (without extension)
#   application yaml file name (without extension)
#   deployment name to rollout (without deployment/)
# OUTPUTS:
#   nothing
# RETURN:
#   0 if succeeds, non-zero on error.
#######################################
deploy_app_with_config() {
  config_output=$(kubectl apply -f "$1-${DEPLOYMENT_TYPE}.yaml")
  app_output=$(envsubst < "$2.yaml" | kubectl apply -f -)

  echo "$config_output"
  echo "$app_output"

  reload_deployment_if_needed "$config_output" "$app_output" "$3"
}

#######################################
# Check deployment rollout status every 10 seconds (max 10 minutes) until complete.
#
# ARGUMENTS:
#   deployment name (without deployment/)
# OUTPUTS:
#   nothing
# RETURN:
#   0 if succeeds, non-zero on error.
#######################################
wait_until_rollout_finish() {
  ATTEMPTS=0
  ROLLOUT_STATUS_CMD="kubectl rollout status deployment/$1"
  until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
    $ROLLOUT_STATUS_CMD
    ATTEMPTS=$((ATTEMPTS + 1))
    echo "wait 10 sec for rollout finish"
    sleep 10
  done
}

error() {
  echo -e "\n\033[0;31mERROR\033[0m Something went wrong on line $1"
}

trap 'error $LINENO' ERR

# shellcheck disable=SC2086
if [ -z ${DEPLOYMENT_TYPE} ]
then
  print_error "DEPLOYMENT_TYPE environment variable is not set!"
  exit 1
fi

ENV_FILE_NAME="../${DEPLOYMENT_TYPE}.env"

[ ! -f "$ENV_FILE_NAME" ] &&  print_error "could not read .env from $ENV_FILE_NAME" && exit 1

# shellcheck disable=SC2046
export $(grep -E -v '^#' "$ENV_FILE_NAME" | xargs)

echo "commons done!!"
