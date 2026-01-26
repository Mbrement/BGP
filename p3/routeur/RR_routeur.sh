#!/bin/bash
#  Not sur if the exit are necessary, I hope yes, but can't/wont test today
routeur(){
	echo "this is RR routeur, it has a fix configuration"
	vtysh << EOF
	configure terminal
	    ip ospf log-adjacency-changes 
		! Turn off IPv6 forwarding, is commented for now
		! no ipv6 forwarding
		interface eth0
		 ip address 10.1.1.1/30
		 ip ospf area 0
		 exit
		interface eth1
		 ip address 10.1.1.5/30
		 ip ospf area 0
		 exit
		interface eth2
		 ip address 10.1.1.9/30
		 ip ospf area 0
		 exit
		! loopback for iBGP sessions, 1.1.1.1 for sandbox purposes
		interface lo0
		 ip address 1.1.1.1/32
		 ip ospf area 0
		 exit
		routeur bgp 1
		 bgp log-neighbor-changes
			neighbor BADASS remote-as 1
			neighbor BADASS update-source lo0
 			 bgp listen range 1.1.1.0/24 peer-group BADASS
			 address-family l2vpn evpn
			  neighbor DYNAMIC activate
			  neighbor DYNAMIC route-reflector-client
			  exit-address-family
		exit
	routeur ospf	
exit


EOF
}

routeur $1


# bgp cluster-id A.B.C.D
# bgp no-rib	
