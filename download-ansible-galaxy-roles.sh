#!/bin/sh -x

ansible-galaxy install -r ansible-requirements.yml -p ansible/roles "$@"

# To list installed roles and their verions
# ansible-galaxy list -p ansible/roles
