set -e

pushd ./ansible > /dev/null

ansible-playbook deploy.yml \
  -i inventory \
  --ssh-extra-args="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" \

popd > /dev/null
