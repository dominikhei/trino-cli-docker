### Introduction 

This is a lightweight docker image for the Trino CLI, built on top of the Linux alpine image.
It can be used for local testing or as an init container in a local Trino project which could create schemas and tables after the Trino server is running.

The container either has to run in the same Docker network as the Trino container or share the hosts network namespace via the --network=host option (If Trino is accessible from localhost).

The Image supports connection to Trino via a __URI__ and if required __user__ and __password__.
If user is left blank the hosts name will be chosen as the user to connect to Trino. 

The following variables are used for this:
- CONNECTION_USER
- CONNECTION_PW
- CONNECTION_URI

Upon startup the Container checks which of these have been provided and tries to connect according to it.
F.e if no password and username have been provided, it will simply try to connect via the uri and hostname.

### Starting the Container

To start the container one has two options:
- as a single container
- in a compose project

__Starting it in a compose project__:

```Dockerfile
version: '3'
services:

    trino-cli:
        build: ./trino-cli
        networks:
            - trino_network
        environment:
            CONNECTION_URI= <uri to connect to your trino instance>
            CONNECTION_USER= <optional>
            CONNECTION_PW= <optional>
        depends_on:
            - trino 
```

__Starting it as a single container:__

```bash
docker run --network=<network_name, f.e host> -e CONNECTION_URI=<uri to connect to your trino instance> -e CONNECTION_USER= <optional> -e CONNECTION_PW= <optional> <image_name>

```

### Accessing the Trino CLI:

To access the CLI you simply have to exec into the container, like the following:

```bash
docker exec -it <container_name> trino
```

### Trino CLI Commands

A reference on commands for the Trino CLI can be found [here](https://trino.io/docs/current/client/cli.html)
