#/bin/sh
routeur(){
    id=$1
    if [ -z "$id" ]; then
        echo "Usage: routeur <id>"
        return 1
    fi
    echo "Configuring routeur with ID: $id"
    brctl addbr br0
    ip addr add 10.1.1.$id dev eth0
    brctl addif br0 eth1
    ip link add vxlan10 type vxlan id 10 remote 10.1.1.${3-$id} local 10.1.1.$id dev eth0 dstport 8472
    ifconfig vxlan10 up
    brctl addif bro vxlan
    ifconfig br0 up
}

routeur $1
