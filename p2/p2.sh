#!/bin/bash
docker ps --format '{{.Names}}' | 
while read -r line; do
    version=$(echo "$line" | sed -E 's/.*mrozniec-([0-9]).*/\1/')
    if [ -z "$version" ]; then
        echo "Could not extract version from container name: $line"
        continue
    fi
    if [[ "$line" == *"host"* ]]; then
	docker cp ./host/host.sh $line:/tmp/script.sh
    elif [[ "$line" == *"routeur"* ]]; then
	if [[ "$1" == "dynamic" ]]; then
	    docker cp ./routeur/dynamic_routeur.sh $line:/tmp/script.sh
	else
            docker cp ./routeur/static_routeur.sh $line:/tmp/script.sh
	fi
    else
        echo "Unknown container type for: $line"
	break
    fi
    docker exec -d $line sh tmp/script.sh "$version"
done
