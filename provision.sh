#!/bin/bash

set -e

pushd ./ansible > /dev/null

ansible-playbook python.yml \
  -i inventory \
  --ssh-extra-args="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" \

ansible-playbook server.yml \
  -i inventory \
  --ssh-extra-args="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" \
  #--extra-vars="username=${USERNAME} docker_version=${DOCKER_VERSION}"

popd > /dev/null
