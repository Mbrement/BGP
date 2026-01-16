#!/bin/bash
docker ps --format '{{.Names}}'  gns| 
while read -r line; do
    version=$(echo "$line" | sed -E 's/.*mrozniec-([0-9]).*/\1/')
    if [ -z "$version" ]; then
        echo "Could not extract version from container name: $line"
        continue
    fi
    if [[ "$line" == *"host"* ]]; then
	docker cp ./host/host.sh $line:/tmp/script.sh
    elif [[ "$line" == *"routeur"* ]]; then
        docker cp ./routeur/static_routeur.sh $line:/tmp/script.sh
    else
        echo "Unknown container type for: $line"
	break
    fi
    echo "docker exec -d $line /tmp/script.sh $version"
    docker exec -d $line /tmp/script.sh "$version"
done
