#!/bin/bash
routeur(){
	echo "this is RR routeur, it has a fix configuration"
	vtysh << EOF
	configure terminal

		! Turn off IPv6 forwarding <-- comment
		no ipv6 forwarding
		interface eth0
		 ip address 10.1.1.1/30
		 exit
		interface eth1
		 ip address 10.1.1.5/30
		 exit
		interface eth2
		 ip address 10.1.1.9/30
		 exit
		! loopback for iBGP sessions, 1.1.1.1 for sandbox purposes
		interface lo0
		 ip address 1.1.1.1/32
		 exit
		routeur bgp 1
		 bgp log-neighbor-changes
			neighbor BADASS remote-as 1
			neighbor BADASS update-source lo0
!		  neighbor 10.1.1.1/30 remote-as 1
!		  neighbor 10.1.1.5/30 remote-as 2
!		  neighbor 10.1.1.5/30 remote-as 3 
! neighbor BADASS update-source		
		exit

exit


EOF
}

routeur $1


# bgp cluster-id A.B.C.D
# bgp no-rib	
