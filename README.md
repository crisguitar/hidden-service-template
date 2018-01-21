# Hidden service

## Requirements

- DigitalOcean account
- DigitalOcean access token (to interact with the HTTP API)
- Have an ssh key uploaded to DigitalOcean. To get the id of the key use the [HTTP API](https://developers.digitalocean.com/documentation/v2/#list-all-keys)
- ansible
- jq

## Steps to deploy hidden service

```
$ AUTH_TOKEN=the_token SSH_KEY_ID=the_id ./create-droplet.sh
$ ./provision.sh
$ ./deploy.sh
```
