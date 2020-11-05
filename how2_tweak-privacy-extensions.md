# IPv6 Privacy Extensions anpassen

Die Erstellung und Verwerfung von *dynamisch* erzeugten *anonymisierten, globalen IPv6-Adressen* sieht in der Praxis nicht besonders dynamisch aus.
Voreingestellt können auf einem Ubuntu 18.04. beispielsweise kurz nach einem Systemstart folgende Werte inspiziert werden:

```
ip a s

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
       valid_lft 132164sec preferred_lft 45764sec
    inet6 fe80::bc4:76b:75d9:b46a/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```

Die Adresse mit den Attributen *scope global temporary dynamic* wird mehr als 12 Stunden aktiv genutzt
und bleibt weitere 24 Stunden für bestehende Verbindungen aktiv.
Nun, das kann man so lassen - muss man aber nicht.
Mehr Dynamik in der Adressvergabe und dem Verwerfen von ausgedienten IPv6-Adressen,
hilft, die Herkunft von IP-Paketen gegenüber Datensammlern besser zu verschleiern.

**Beispiel:** Die Nutzungsdauer einer IPv6 mit Privacy Extensions soll auf dreißig Minuten beschränkt werden.
Diese (veraltete [deprecated]) Adresse soll noch eine Stunde für bestehende Verbindungen zur Verfügung stehen.
Dieses Szenario ist beispielsweise dann sinnvoll,
wenn der Rechner ausschließlich zur Bewegung im WWW genutzt wird.
Für Server und Service-Rechner,
die stabile stehende Verbindungen,
beispielsweise per SSH benötigen,
sollte ein anderer Plan in Erwägung gezogen werden.

Anonymisierte globale IPv6-Adressen werden in der Datei */etc/sysctl.d/10-ipv6-privacy.conf* konfiguriert:
```
sudo nano /etc/sysctl.d/10-ipv6-privacy.conf
```

Der originale Inhalt:
```
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
```

... wird ergänzt mit folgenden Zeilen:
```
net.ipv6.conf.eno1.temp_prefered_lft = 1800
net.ipv6.conf.eno1.temp_valid_lft = 5400
```

Die neuen Einstellungen werden übernommen mit:
```
sudo sysctl -p /etc/sysctl.d/10-ipv6-privacy.conf
```
Nach dem Neustart des Netzwerkes oder des Rechners können die neuen Einstellungen überprüft werden:

```
ip a s

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
    inet6 2a02::::e1e7:56db:c0fd:16c3/64 scope global temporary dynamic 
       valid_lft 5398sec preferred_lft 1454sec
    inet6 fe80::bc4:76b:75d9:b46a/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```
