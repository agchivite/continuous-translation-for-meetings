#!/bin/bash

sudo docker network create public-argos-network

bash argos_api_bash_deploy.sh
