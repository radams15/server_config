Title: Connecting a vintage PC to the web over serial
Tags: vintage computers, t3100e
Published: 29/06/2023

---
# Connecting a vintage PC to the web over serial

Not satisfied with having my laptop from 1996 connected to the internet, I turned to my massive brick of a luggable: the Toshiba t130e from 1987.

## Software

Whilst conceptually this should be easier than with the Satellite, finding the correct packet driver for serial PPP networking was more difficult. Many websites
referenced the dosppp software, but very few gave a download.

Eventually I found the download [here](https://misterfpga.org/viewtopic.php?t=896). I copied these files to the Toshiba with a floppy and placed them into
the `C:\dosppp` folder.

I then downloaded [mTCP](http://brutmanlabs.org/mTCP/) and unzipped it to the `C:\mtcp` folder.

The router I chose was my server machine - an HP Elitebook 8570p. I chose this for 2 reasons:

- It was already plugged in and running 24/7
- It has a real serial port

## Wiring

The wiring was simple. All I needed was a **null-modem cable** (a normal serial cable will not work).

I connected one end of the cable to the server, and one to the Toshiba.


![The serial port on the Toshiba](static/images/serial_networking/ports.jpg)


## Starting PPPd

On the server side, I ran the following commands (as root):

`# sysctl net.ipv4.ip_forward=1` - This allows the server to forward packets like a router.

`# iptables -t nat -A POSTROUTING -o br0 -j MASQUERADE` - This bridges the serial interface to the main interface.

`# pppd ttyS0 19200 local lock passive proxyarp defaultroute noauth mtu 576 10.0.1.1:10.0.1.2` - This starts pppd (see the IPs at the end in the form server:client).

I put this in a script named `ppp.sh`.

![ppp.sh](static/images/serial_networking/server_script.png)


## Connecting on the Toshiba

Dosppp was an easy setup. The command to run start it is simply: `epppd com1 19200 local`. The com1 was the port I plugged the serial cable into, the Toshiba has
2 serial ports so this could have been com2 if I plugged it in there. This tells me the packet interrupt selected - mine was 0x60.

![Starting epppd](static/images/serial_networking/epppd.jpg)

In the `C:\mtcp` folder I edited mtcp.cfg to read the following: 

`PACKETINT 0x60` - the packet interrupt I was given

`HOSTNAME BIGBRICK`

`IPADDR 10.0.1.2`

`NETMASK 255.255.255.0`

`GATEWAY 10.0.1.1`

`NAMESERVER 1.1.1.1`

![mtcp.cfg](static/images/serial_networking/mtcpcfg.jpg)

I then set the variable `MTCPCFG` to the location of the mtcp.cfg: `set MTCPCFG=C:\mtcp\mtcp.cfg`. Put this in `autoexec.bat` if you want.

Here I've given the new network the subnet of `10.0.1.0/24` with the server being `10.0.1.1` and the Toshiba being `10.0.1.2`.

Then I can test by pinging cloudflare dns: `ping 1.1.1.1`.

![Ping successful](static/images/serial_networking/ping.jpg)

We can then do whatever we want on the internet.

![Set the time over sntp](static/images/serial_networking/sntp.jpg)

![Telnet to my server](static/images/serial_networking/telnet.jpg)