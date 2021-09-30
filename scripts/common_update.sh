#!/bin/bash

# parent script should define images_list array as
#image_name;image_version;deployment_name;container_name

# shellcheck disable=SC2154
for i in "${images_list[@]}"
do
  IFS=';' read -ra CONF <<< "$i"
  kubectl set image --record "deployment/${CONF[2]} ${CONF[3]}=${CONF[0]}:${CONF[1]}"
done
