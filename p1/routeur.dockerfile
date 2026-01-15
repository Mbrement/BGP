FROM quay.io/frrouting/frr:10.2.5

RUN apk add --no-cache busybox

RUN sed -i 's/^#\?zebra=.*/zebra=yes/' /etc/frr/daemons
RUN sed -i 's/^#\?bgpd=.*/bgpd=yes/' /etc/frr/daemons
RUN sed -i 's/^#\?ospfd=.*/ospfd=yes/' /etc/frr/daemons
RUN sed -i 's/^#\?isisd=.*/isisd=yes/' /etc/frr/daemons
