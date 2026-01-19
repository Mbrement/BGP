#!/bin/ash

host(){
    id=$1
    if [ -z "$id" ]; then
        echo "Usage: host <id>"
        return 1
    fi
    echo "Configuring host with ID: $id"
    ip addr add 30.1.1.$id/24 dev eth1
}

host $1
