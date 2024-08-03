#!/bin/bash

cd ../../back
sudo docker compose down
sudo docker rmi -f argos-api_argos
sudo docker compose up -d