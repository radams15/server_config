Title: One samba server for Windows 3.11 and 10
Tags: vintage computers, networking
Published: 13/07/2023
Disabled: 1

---
# One samba server for Windows 3.11 and 10

This is one of those things that I thought would be cool to do but had no real need for. It is trivially easy to mount a windows 3.11 share onto Windows 10, and easy for the same Windows 10 to mount a samba share, allowing the Windows 10 box to copy files from one to the other as a bridge machine. This, however, was still too much effort for me - so I spent hours trying to get them both to connect to the same server.

Since this would be a very insecure share, I made a dedicated VM for it, running Ubuntu 20.04.

Here is the final version of the samba share:

	[global]
			netbios name = SERVER
			workgroup = ORA # The workgroup to connect to
			security = user # Minimal security level
			encrypt passwords = yes # They are encrypted, but not very much
			passdb backend = smbpasswd # Use smbpasswd to manage user passwords

			# Minimal, Windows 3.11 authentication methods
			lanman auth = yes
			wins support = yes
			ntlm auth = yes
			min protocol = CORE
			max protocol = SMB3

			# Be a domain controller
			domain master = yes
			domain logons = yes
			preferred master = yes
			local master = yes
			enable privileges = yes
			os level = 33 # Higher privilege than any windows server could be

			# What to do when a new machine or user connects
			add group script = /etc/samba/smbgrpadd.sh "%g"
			add machine script = /usr/sbin/useradd -g users -s /bin/false '%u'
			logon script = logon.bat # Execute this program on login
			logon path = \\server\%U\profile-%a # Where profile is stored on the server

	[share] # Public share for everybody
			path = /mnt/share
			read only = no

	[homes] # User home directories (\\SERVER\user)
			comment = homes
			browseable = No
			read only = No
			inherit acls = Yes

	[netlogon] # Domain controller required share, can place scripts here, etc.
			comment = Net Logon service
			path = /data/netlogon
			read only = yes
			write list = +ntadmin # Only let admins write here
			public = no
			writeable = no
			browseable = no


The only trouble I faced after this setup was that the logon.bat script was not executing. The problem I found was that it needed to be set executable on the server side, so a simple `chmod +x logon.bat` fixed the issue.

## Connecting Windows XP

XP was the first system I attempted to connect with.

I went to Control panel -> Computer name -> change, then changed the domain to 'ORA'.

It showed me a success message, then I needed to reboot my PC.

![Successful domain connection](static/images/vintage_samba/xp_domain_connected.PNG)

Because of my logon script, the shares auto-mounted and I could browse my shares correctly.

![Successful mounts](static/images/vintage_samba/xp_shares_connected.PNG)

## Connecting Windows 3.11 for Workgroups

The most complicated one was Windows 3.11, for obvious reasons.

Under Control panel -> Microsoft Windows network -> Startup settings, I ticked 'Log on to Windows NT or LAN Manager domain', then put 'ORA' into the domain name field.

![Network Settings](static/images/vintage_samba/31_network_settings.PNG)
![Startup Settings](static/images/vintage_samba/31_startup_settings.PNG)
![Successful mounts](static/images/vintage_samba/31_shares_connected.PNG)

## Connecting Windows 10

This was basically identical to Windows XP, surprising that nothing has changed in over 20 years, but nothing is wrong with that!

The only things I needed to do was change the following registry settings:

`HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters\DomainCompatibilityMode = 1`

`HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters\DNSNameResolutionRequired = 0`

![Successful mounts](static/images/vintage_samba/10_shares_connected.PNG)
