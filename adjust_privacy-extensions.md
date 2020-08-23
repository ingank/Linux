# IPv6 Privacy Extensions anpassen

### Aufgabe
Die Nutzungsdauer einer IPv6 mit Privacy Extensions soll auf dreißig Minuten
beschränkt werden. Diese dann veraltete [deprecated] Adresse soll noch eine
weitere Stunde für bestehende Verbindungen zur Verfügung stehen.

### Lösungsansatz
```
$ sudo nano /etc/sysctl.d/10-ipv6-privacy.conf
# IPv6 Privacy Extensions (RFC 4941)
# ---
# IPv6 typically uses a device's MAC address when choosing an IPv6 address
# to use in autoconfiguration. Privacy extensions allow using a randomly
# generated IPv6 address, which increases privacy.
#
# Acceptable values:
#    0 - don’t use privacy extensions.
#    1 - generate privacy addresses
#    2 - prefer privacy addresses and use them over the normal addresses.
net.ipv6.conf.all.use_tempaddr = 2
net.ipv6.conf.default.use_tempaddr = 2
net.ipv6.conf.eno1.temp_prefered_lft = 1800
net.ipv6.conf.eno1.temp_valid_lft = 5400

$ sudo sysctl -p /etc/sysctl.d/10-ipv6-privacy.conf
net.ipv6.conf.all.use_tempaddr = 2
net.ipv6.conf.default.use_tempaddr = 2
net.ipv6.conf.eno1.temp_prefered_lft = 1800
net.ipv6.conf.eno1.temp_valid_lft = 5400
```

Nach dem Neustart des Netzwerkes können die Einstellungen begutachtet werden:
```
$ ip a s
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether f8:b1:56:ab:d9:17 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.10/24 brd 192.168.0.255 scope global noprefixroute eno1
       valid_lft forever preferred_lft forever
    inet6 2a02::::d836:dd4e:2a7c:cdd6/64 scope global temporary dynamic 
       valid_lft 5380sec preferred_lft 1223sec
    inet6 fe80::bc4:76b:75d9:b46a/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```
