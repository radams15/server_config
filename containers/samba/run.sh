#!/bin/bash

podman run --net host -it --rm -v ./home:/home:z -v ./netlogon:/netlogon:z -v ./share:/share:z -v ./samba:/etc/samba:z samba
