
iptables -t raw -A PREROUTING -p udp --dport 8000 -j NOTRACK
iptables -t raw -A PREROUTING -p udp --sport 8000 -j NOTRACK


iptables -t raw -A OUTPUT -p udp --dport 8000 -j NOTRACK
iptables -t raw -A OUTPUT -p udp --sport 8000 -j NOTRACK

iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED,UNTRACKED -j ACCEPT

sysctl -w net.nf_conntrack_max=256536
sysctl -w net.netfilter.nf_conntrack_max=256536

iptables -L -t raw
