#/bin/sh

host(){
    id=$1
    if [ -z "$id" ]; then
        echo "Usage: host <id>"
        return 1
    fi
    echo "Configuring host with ID: $id"
    # ip addr add 10.1.1.$id dev eth1
}

host $1
