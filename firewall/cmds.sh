iptables -F
iptables --policy INPUT DROP
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s localhost -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i ppp0 -j ACCEPT
iptables -t nat -A POSTROUTING -o br0 -j MASQUERADE
iptables -A INPUT -m state --state NEW -i br0 -p udp --dport 137 -j ACCEPT
iptables -A INPUT -m state --state NEW -i br0 -p tcp --dport 137 -j ACCEPT
iptables -A INPUT -m state --state NEW -i br0 -p udp --dport 178 -j ACCEPT
iptables -A INPUT -m state --state NEW -i br0 -p tcp --dport 178 -j ACCEPT
iptables -A INPUT -m state --state NEW -i br0 -p udp --dport 139 -j ACCEPT
iptables -A INPUT -m state --state NEW -i br0 -p tcp --dport 139 -j ACCEPT
iptables -A INPUT -m state --state NEW -i br0 -p udp --dport 445 -j ACCEPT
iptables -A INPUT -m state --state NEW -i br0 -p tcp --dport 445 -j ACCEPT
iptables -A INPUT -m state --state NEW -i br0 -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -m state --state NEW -i br0 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables-save > /etc/sysconfig/iptables
