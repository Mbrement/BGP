#!/bin/bash
# docker ps --format '{{.Names}}'  
echo "GNS3.routeur_mrozniec-2.bb3303b2-6023-4180-847b-e01ac021b7bd
GNS3.host_mrozniec-2.bb3303b2-6023-4180-847b-e01ac021b7bd
GNS3.routeur_mrozniec-1.bb3303b2-6023-4180-847b-e01ac021b7bd
GNS3.host_mrozniec-1.bb3303b2-6023-4180-847b-e01ac021b7bd"| 
while read -r line; do
    version=$(echo "$line" | sed -E 's/.*mrozniec-([0-9]).*/\1/')
    if [ -z "$version" ]; then
        echo "Could not extract version from container name: $line"
        continue
    fi
    if [[ "$line" == *"host"* ]]; then
        docker exec -d $line ./host/host.sh "$version"
    elif [[ "$line" == *"routeur"* ]]; then
        docker exec -d $line ./routeur/static_routeur.sh "$version"
    else
        echo "Unknown container type for: $line"
    fi
done
