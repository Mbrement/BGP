#/bin/sh
docker ps --format '{{.Names}}'  | 
while read -r line; do
    version=$(echo "$line" | sed -E 's/.*mrozniec-([0-9]).*/\1/')
    docker exec -d $line ./host/host.sh "$version"
done
