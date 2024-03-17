#!/bin/bash

# Start NGINX in the background
nginx

# Execute the command passed to the docker container
exec yarn run "$@"
