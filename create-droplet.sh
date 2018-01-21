#!/bin/bash

set -e

if [[ -z "${AUTH_TOKEN}" || -z "${SSH_KEY_ID}" ]]; then
  echo "Provide AUTH_TOKEN and SSH_KEY_ID"
  exit 1
fi

droplet_name="hidden-service"
base_url="https://api.digitalocean.com/v2"
auth_header="Authorization: Bearer ${AUTH_TOKEN}"

get_ip_address() {
  curl -s "${base_url}/droplets" -H "${auth_header}" | \
    jq -r '.droplets | .[] | select(.name=="hidden-service") | .networks.v4 | .[].ip_address'
}

droplets=$(curl -s "${base_url}/droplets" -H "${auth_header}" | jq ".droplets | .[] | .name")

if [[ $droplets == *"${droplet_name}"* ]]; then
  echo "Droplet already exist. Skipping creation."
  exit 0
else
  echo "Creating droplet '${droplet_name}'"
  curl -s -X POST "${base_url}/droplets" \
    -d "{\"name\":\"${droplet_name}\",\"region\":\"fra1\",\"size\":\"s-1vcpu-1gb\",\"image\":\"ubuntu-16-04-x64\",\"ssh_keys\":[${SSH_KEY_ID}]}" \
    -H "${auth_header}" \
    -H "Content-Type: application/json" | jq ".droplet | { id, name, memory, vcpus, disk, created_at }"
  echo "Droplet created"
fi

printf "Getting droplet IP address"
attempt=0
while [[ -z $droplet_ip ]] && [ $attempt -lt 20 ]
do
  printf "."
  droplet_ip=$(get_ip_address)
  attempt=$[$attempt+1]
  sleep 2
done

if [[ -z $droplet_ip ]]; then
  echo "Could not obtain IP Address after 20 attempts."
  echo "Go to Digital Ocean console and update the ./ansible/inventory file manually."
  echo "[server]"
  echo "xx.xx.xx.xx"
  echo "Or re run this script."
  exit 1
fi

echo ""
echo "IP: ${droplet_ip}"
echo "[server]" > ansible/inventory
echo $droplet_ip >> ansible/inventory
