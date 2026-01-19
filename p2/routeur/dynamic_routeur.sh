#!/bin/bash
routeur(){
    id=$1
    if [ -z "$id" ]; then
        echo "Usage: routeur <id>"
        return 1
    fi
    echo "Configuring routeur with ID: $id"
    brctl addbr br0
    ip addr add 10.1.1.$id/24 dev eth0
    echo "ip link add name vxlan10 type vxlan id 10 remote 10.1.1.$((3-$id)) local 10.1.1.$id dev eth0 dstport 4789"
    ip link add name vxlan10 type vxlan id 10 group 239.1.1.1 dev eth0 dstport 4789
    ip addr add 20.1.1.$id/24 dev vxlan10
    ifconfig br0 up
    ifconfig vxlan10 up
    brctl addif br0 eth1
    brctl addif br0 vxlan10
}

routeur $1
