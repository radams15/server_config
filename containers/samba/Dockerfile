FROM ubuntu:20.04

RUN apt-get update && apt-get install -y samba net-tools

RUN groupadd ntusers && groupadd ntadmins && groupadd nobody

RUN net groupmap add ntgroup="Domain Admins" unixgroup=ntadmins rid=512 type=d && net groupmap add ntgroup="Domain Users" unixgroup=ntusers rid=513 type=d && net groupmap add ntgroup="Domain Guests" unixgroup=nobody rid=514 type=d

COPY entry.sh /

ENTRYPOINT ["/entry.sh"]
