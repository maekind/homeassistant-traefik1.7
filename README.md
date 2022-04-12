# homeassistant-traefik1.7
This is a sample configuration for home assistant docker behind the Traefik 1.7 reverse proxy

## Usage
To use this docker-compose configuration you can clone the repository as follows:

    $>git clone https://github.com/maekind/homeassistant-traefik1.7.git

## Manual configuration

I have put some tags in to the configuration files that have to be replaced before running the docker compose file.

- docker-compose.yaml

    For the traefik configuration we have to set up some parameters:

    - <TRAEFIK_SUBDOMAIN_DOMAIN_NAME>: This is the traefik dashboard entry. I use duckdns so, in my case, the domain name would be something as "maekind.duckdns.org" and the subdomain "traefik". Thus, in my case, the tag should be replaced by "traefik.maekind.duckdns.org" to reach the traefik dashboard.

    - <TRAEFIK_GATEWAY_IP_ADDRESS>: The traefik gateway is needed for traefik to reach your homeassistant container, becasue it will be configured in *host* mode to use de discovery functionality. 
    
        To check for the traefik gateway, you have to start your traefik container and then launch the following command:

        >docker inspect traefik

        This command will show the traefik container configuration. You should search for the following configuration:

            "Networks": {
                    "traefik_net": {
                        "IPAMConfig": null,
                        "Links": null,
                        "Aliases": [
                            "2e2c9f75be7e",
                            "traefik"
                        ],
                        "NetworkID": "ce32f8ecff12eedb85eac25ce0f276e2866e6ae58557a465ebf78bc1cd99305d",
                        "EndpointID": "3e0c0c51baa37571c4c7cb889d7e163c10e968a82996876deaa6fa069dc7a17c",
                ------->"Gateway": "172.19.0.1",
                        "IPAddress": "172.19.0.4",
                        "IPPrefixLen": 16,
                        "IPv6Gateway": "",
                        "GlobalIPv6Address": "",
                        "GlobalIPv6PrefixLen": 0,
                        "MacAddress": "02:42:ac:13:00:04",
                        "DriverOpts": null
                    }
                }
    - <YOUR_USER_ID>: Home assistant container needs the user id that will run the container. You can check it out with the following command:

        >id

        The output should be something like this:

        >uid=1000(marco) gid=1000(marco)

        The *uid* number is your user id.

    - <YOUR_GROUP_ID>: Home assistant container also needs the group id. It is the value *gid* output from the previous command.

    - <HOMEASSISTANT_SUBDOMAIN_DOMAIN_NAME>: This is the home assistant external subdomain, from which home assistant will be reachable throw traefik. In my case, it is "ha.maekind.duckdns.org".

- treafik/traefik.toml
    
    This file contains traefik configuration for http and https requests. 
    
    - The **[entrypoints]** section spcefies the port that opens the traefik dashboard as well as the username and password to login. <YOUR_PASSWORD> tag has to be replaced with your hashed password in md5, sha1 or BCrypt. Your can use the following command to generate your password from the *apache2-tools* package:

        >htpasswd -nb admin <your_password>

    - The **[acme]** section is used to configure the web certificates storage for the https. You have to replace the <YOUR_EMAIL> with your email.

    - The **[docker]** section defines your domain name and the docker network to use. You have to replace the tag <YOUR_DOMAIN_NAME> with your domain name.

- traefik/providers

    This directory contains the redirects to the hosts external to the traefik container. This configuration is needed because we use the homeassistant container in "host" mode, thus it is not in the same network as traefik.

    - In your **[backend]** configuration you have to specify the host ip address, replacing the tag <YOUR_HOST_IP_ADDRESS>.

    - In your **[frontend]** configuration you have to specify your homeassitant subdomain, replacing the tag <HOMEASSISTANT_SUBDOMAIN_DOMAIN_NAME>. For instance, in my case would be "ha.maekind.duckdns.org"

    Then, when traefik receives a request to the "ha.maekind.duckdns.org", it will be redirect to your host ip port 8123, where homeassistant is listenning.

- homeassistant/configuration.yaml

    We have to set up some parameters in the homeassistant's configuration file to accept traefik incoming requests. You have two options: option 1 is to copy the configuration file provided in this repo; option 2 is to copy and paste the **[http]** section in to your own configuration file.

    You have to replace the tag <TRAEFIK_NETWORK> with the traefik network. You can extract the traefik network from the traefik gateway found previously. Thus, if your gateway was 172.19.0.1, the traefik network is 172.19.0.0/16.

## Configuration helper

Now that we have understood how traefik and homeassitant are configured together, you can use the *configure.sh* sript to replace automatically all configuration tags. The simpliest way is to edit the config.txt file and fullfil the variables. Then, you launch the script and the configuration files will be updated.

## Notes

- The homeassistant configuration file is very sensitive to tabs or spaces. So, you have to be sure that there are spaces instead tabs, if not the configuration file won't be loaded.

- As you have seen, the traefik container uses a *traefik_net* network, that is external to the container. You can create the network with following command:

    >docker network create traefik_net

    This command should create a docker network in bridge mode. For more information about network types, refer to https://docs.docker.com/network/.


- Traefik comes with a lot of functionality. You can check traefik documentation in https://doc.traefik.io/traefik/v1.7/.

- For a detailed home assistant configuration, you can check out the home assistant documentation website in https://www.home-assistant.io/docs/.

## Credits
Marco Espinosa (c) 2022 

Say hello: hi@marcoespinosa.es

Check my other repositories at https://github.com/maekind.












 

    
























