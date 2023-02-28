#!/usr/bin/perl

my $INTERFACE = "br0";

my @SMB_PORTS = (137, 178, 139, 445); 

sub policy {
	print "iptables -F\n";
	print "iptables --policy INPUT DROP\n";
	print "iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT\n";
	print "iptables -A INPUT -p tcp -s localhost -j ACCEPT\n";
}

sub allow_samba {
	foreach my $port (@SMB_PORTS) {
		foreach my $proto ('udp', 'tcp') {
			print "iptables -A INPUT -m state --state NEW -i $INTERFACE -p $proto --dport $port -j ACCEPT\n";
		}
	}
}


sub allow_samba_from {
	foreach my $ip (@_){
		foreach my $port (@SMB_PORTS) {
			foreach my $proto ('udp', 'tcp') {
				print "iptables -A INPUT -m state --state NEW -i $INTERFACE -p $proto -s $ip --dport $port -j ACCEPT\n";
			}
		}
	}	
}

sub allow_ssh {
	print "iptables -A INPUT -m state --state NEW -i $INTERFACE -p tcp --dport 22 -j ACCEPT\n";
}

sub allow_http {
	print "iptables -A INPUT -m state --state NEW -i $INTERFACE -p tcp --dport 80 -j ACCEPT\n";
}

sub allow_ping {
	print "iptables -A INPUT -p icmp -j ACCEPT\n";
}

sub allow_localhost {
	print "iptables -A INPUT -i lo -j ACCEPT\n";
	print "iptables -A INPUT -i ppp0 -j ACCEPT\n";
	print "iptables -t nat -A POSTROUTING -o br0 -j MASQUERADE\n"; # This allows arp to work with ppp over serial.
}

sub save {
	print "iptables-save > /etc/sysconfig/iptables\n";
}

open FH, '>', 'cmds.sh';
select FH; # Output every subsequent print statement to the file.

&policy;
&allow_localhost;
#&allow_samba_from('172.29.74.142', '172.26.251.55');
&allow_samba;
&allow_http;
&allow_ssh;
&allow_ping;

&save;
close FH;
