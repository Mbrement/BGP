#!/bin/bash
routeur(){
	if [ "$1" -eq 2 ]; then
		id=1
		lo_id=2
	elif
	 [ "$1" -eq 3 ]; then
		id=5
		lo_id=3
	else
		id=9
		lo_id=4
	fi
	router_eth=$(($1-2))
	if [ $1 -eq 2 ]; then
		host_eth=1
	else
		host_eth=0
	fi
    if [ -z "$id" ]; then
        echo "Usage: routeur <id>"
        return 1
    fi
	echo "Configuring routeur with ID: $id"
    brctl addbr br0
    ip addr add 10.1.1.$id/24 dev eth$router_eth
    echo "ip link add name vxlan10 type vxlan id 10 remote 10.1.1.$((3-$id)) local 10.1.1.$id dev eth$router_eth dstport 4789"
    ip link add name vxlan10 type vxlan id 10 group 239.1.1.1 dev eth0 dstport 4789
    ip addr add 20.1.1.$id/24 dev vxlan10
    ifconfig br0 up
    ifconfig vxlan10 up
    brctl addif br0 eth$host_eth
    brctl addif br0 vxlan10

	vtysh << EOF
		configure terminal
		no ipv6 forwarding
		ip ospf log-adjacency-changes

		interface eth$router_eth
		 ip address 10.1.1.$(($id+1))/30
		 ip ospf area 0
		 exit
		interface lo
		 ip address 1.1.1.$(($lo_id))/32
		 ip ospf area 0
		 exit
		router bgp 1
			neighbor BADASS remote-as 1
			neighbor BADASS update-source lo
			address-family l2vpn evpn
			advertise-all-vni
			exit-address-family
		exit
		wr
	exit
EOF

}

routeur $1
