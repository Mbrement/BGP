#!/usr/bin/env bash

docker build -t mrozniec/host -f host.dockerfile .
docker build -t mrozniec/routeur -f routeur.dockerfile .