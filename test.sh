#!/bin/bash
scrit (){
	text=$(($1-1))
 echo "test.sh
 test
 p" |
while read -r line; do
	cat << EOF
	$text
EOF

	done
}
scrit $1