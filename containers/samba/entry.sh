#!/bin/bash

/etc/samba/init.sh

/etc/init.d/smbd start
/etc/init.d/nmbd start

/sbin/ifconfig

#read end
bash
