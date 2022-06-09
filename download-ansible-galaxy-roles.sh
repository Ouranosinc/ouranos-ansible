#!/bin/sh -x

ansible-galaxy install -r ansible-requirements.yml -p ansible/roles "$@"
