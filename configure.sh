#!/bin/bash
# Configuration helper for homeassistant and traefik 1.7

# files
dockercompose='./dist/docker-compose.yaml'
traefik='./dist/traefik/traefik.toml'
provider='./dist/traefik/providers/homeassistant.toml'
homeassistant='./dist/homeassistant/configuration.yaml'
config='./config.txt'

echo 'Creating dist folder ...'
mkdir ./dist 2>> /dev/null
echo 'Copying files to dist folder ...'
cp -f ./docker-compose.yaml ./dist/.
cp -Rf ./traefik ./dist/.
cp -Rf ./homeassistant ./dist/.

echo 'Configuring ...'

. ./config.txt

sed -i "s/<TRAEFIK_SUBDOMAIN_DOMAIN_NAME>/$TRAEFIK_SUBDOMAIN_DOMAIN_NAME/" $dockercompose
sed -i "s/<TRAEFIK_GATEWAY_IP_ADDRESS>/$TRAEFIK_GATEWAY_IP_ADDRESS/" $dockercompose
sed -i "s/<YOUR_USER_ID>/$YOUR_USER_ID/" $dockercompose
sed -i "s/<YOUR_GROUP_ID>/$YOUR_GROUP_ID/" $dockercompose
sed -i "s/<HOMEASSISTANT_SUBDOMAIN_DOMAIN_NAME>/$HOMEASSISTANT_SUBDOMAIN_DOMAIN_NAME/" $dockercompose
sed -i "s/<YOUR_PASSWORD>/$YOUR_PASSWORD/" $traefik
sed -i "s/<YOUR_EMAIL>/$YOUR_EMAIL/" $traefik
sed -i "s/<YOUR_DOMAIN_NAME>/$YOUR_DOMAIN_NAME/" $traefik
sed -i "s/<YOUR_HOST_IP_ADDRESS>/$YOUR_HOST_IP_ADDRESS/" $provider
sed -i "s/<HOMEASSISTANT_SUBDOMAIN_DOMAIN_NAME>/$HOMEASSISTANT_SUBDOMAIN_DOMAIN_NAME/" $provider
sed -i "s!<TRAEFIK_NETWORK>!$TRAEFIK_NETWORK!" $homeassistant

echo 'Done'
