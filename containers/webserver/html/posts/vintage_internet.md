Title: Connecting a vintage laptop to the internet.
Tags: vintage computers, website
Published: 28/06/2023

---
# Connecting a vintage laptop to the internet

It was only recently that I began collecting truly vintage computers. For a while I had quite a few laptops from the early 2000s such
as Powerbooks, iBooks and later Thinkpads, but at the beginning of the year I purchased a very old Toshiba 3100e - a luggable from 1987 which
ignited my love for DOS PCs.

Whilst that PC will not be connecting to the internet soon due to it's only expansion being a single 8-bit ISA slot, another laptop I purchased recently
would be - a 1996 Toshiba Satellite 200CDS which I installed MS-DOS 6.22 on because It's so much faster on the old HDD than the preinstalled Windows 95.

## The hardware

The 200CDS has 2 PC Card slots which I would be using.

After searching for a while for a compatible card, I decided on the Cisco Aironet 350 because it was PC-Card compatible (PCMCIA cards won't work),
and I could get it for less than £15 delivered.

![The laptop and the PC card](static/images/vintage_internet/laptop_card.jpg)

For the wireless access point I am using a TP-Link archer C6 running OpenWRT. I like this router as it was quite cheap (around £40) and offers gigabit
ethernet along with both 5GHz and 2.4GHz. OpenWRT therefore allows me to run 2 networks - one 5GHz with WPA2 for my modern devices, and one with WEP for
devices like this (which can be easily disabled once I'm finished).

![The router](static/images/vintage_internet/router.jpg)

## The software

As previously mentioned, the laptop is running MS-DOS 6.22 as it's nice and snappy due to it being about 5 years too old for the hardware.

The router is running OpenWRT, but I needed to recompile the OS to enable WEP as this had been recently disabled in OpenWRT for obvious security
reasons. I did this by setting `WPA_ENABLE_WEP=y` in the kernel config, compiling the kernel then flashing the system image to the device as an update.

Tracking down the software for the Aironet 350 was somewhat difficult, but once I found the zip file `aironet350_dos.zip`, everything started to come together.

I first copied the drivers (unzipped) to a floppy and copied them into a folder named `C:\wlan` on the Satellite.

The first step is to issue the command `pcmcia on`, which enabled the PC Card bus. This gives us the 'IO Base Address' of the bus which we will need later.
Here it is `0x180`.

![Enabling the PC Card](static/images/vintage_internet/pc_card.jpg)

We then need to program in the WPA passkey. Here I'm setting an example WEP key 1 to `passw`, which is a terrible passkey, especially as it uses only one of
the 4 available keys.

To do this we issue the command `wepdos -365 -p 0x180 -ascii -key1 passw`, replacing 0x180 with your IO base address. You can repeat this with keys 1-4 if you
have set them up on the WAP.

![Setting the WEP key](static/images/vintage_internet/wepdos.jpg)

The next step is to configure the `cscpkt` driver - the packet driver for the Aironet 350. Open up cscpkt.ini in MS-DOS edit and change (and uncomment)
the following values:

- SSID => The SSID of your access point
- AuthType => WEPOPEN
- PortBase => 0x180 - The IO Base Address
- Memory => 0xD000 - The conventional base address of PC cards
- Socket => 0 (Assuming the card is in socket 0)

![cscpkt.ini part 1](static/images/vintage_internet/cscpkt_1.jpg)

![cscpkt.ini part 2](static/images/vintage_internet/cscpkt_2.jpg)


The interesting part here is the auth type being set to open. This is because WEPDOS actually flashes the WEP keys to NVRAM on the Aironet card, which makes
DOS think that the access point is open, whereas in reality the adapter is communicating over WEP and transparently returning plain data to DOS.

Next, we start the packet driver with the command `cscpkt 0x62` - which starts the packet driver at interrupt 0x62. This can be set to any number of interrupts
but mine is 0x62 because I have another network card that had interrupt 0x62 hard-coded so I keep this interrupt for consistency.

![cscpkt.ini part 2](static/images/vintage_internet/start_cscpkt.jpg)

At this point the packet driver has been setup and layer 2 communication can occur. We now need a layer 3 (TCP/IP) program.

For this I chose [mTCP](http://brutmanlabs.org/mTCP/) which is relatively small and easy to setup. I downloaded the files into a folder `C:\mtcp` on the
satellite using a floppy.

We then create a file named `mtcp.cfg` with the following contents:

`PACKETINT 0x62`

`HOSTNAME Satellite`

`DOMAIN lan`

`IPADDR 10.0.0.153`

`NETMASK 255.255.255.0`

`GATEWAY 10.0.0.1`

`NAMESERVER 10.0.0.1`

![mTCP.cfg](static/images/vintage_internet/mtcp.jpg)

This tells mTCP programs to use the IP address of `10.0.0.153`, the gateway of `10.0.0.1` and the packet interrupt of `0x62`.

The last thing to do is to set the `MTCPCFG` variable to the location of the mtcp.cfg script. we do this with the command: `set MTCPCFG=C:\mtcp\mtcp.cfg`
(this can be put into autoexec.bat to be set at launch).

![pinging works](static/images/vintage_internet/ping.jpg)

As we can see now, the mTCP programs function correctly and we can ping 1.1.1.1.