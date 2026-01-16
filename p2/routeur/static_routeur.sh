#/bin/sh
routeur(){
    id=$1
    if [ -z "$id" ]; then
        echo "Usage: routeur <id>"
        return 1
    fi
    echo "Configuring routeur with ID: $id"
    # brctl addbr br0
    # ip addr add 10.1.1.$id dev eth0
    # brctl addif br0 eth1
    # ifconfig br0 up
}

routeur $1
