#/bin/sh
docker ps --format '{{.Names}}'  | 
while read -r line; do
    version=$(echo "$line" | sed -E 's/.*mrozniec-([0-9]).*/\1/')
    ./host/host.sh "$version"
done
