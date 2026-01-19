#!/bin/ash

host(){
    id=$1
    if [ -z "$id" ]; then
        echo "Usage: host <id>"
        return 1
    fi
    echo "Configuring host with ID: $id"
	if [ "$id" -eq 1 ]; then
    	ip addr add 20.1.1.$id/24 dev eth0
	else
		ip addr add 20.1.1.$id/24 dev eth1
	fi

}

host $1
