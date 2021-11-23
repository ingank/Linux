# DS-Lite: SSH-Fernwartung per Jumpserver

Szenario:
- GNU/Linux auf einem Rechner im lokalen Netzwerk im Dauerbetrieb (z.B. Raspberry Pi)
- Internetzugang aus dem lokalen Netzwerk per DS-Lite Gateway

Wunsch:
- von einem mobilen Gerät (IPv4) oder
- von einem anderen Rechner (IPv6)
- aus dem Internet
- per ssh auf den lokalen Rechner zugreifen

## Diagnose

Welche technischen Eigenheiten müssen bei der Verwirklichung dieses Wunsches beachtet werden?

### DSLite und IPv4: Katz und Maus

Grundsätzlich sind alle Rechner im lokalen Netzwerk
über das DS-Lite-Gateway
direkt aus dem Internet erreichbar;
sie sind Teil des routbaren Internets.
Diese Aussage bezieht sich jedoch ausschließlich
auf den mit IPv6 addressierten Bereich.

Ganz anders sieht es bei IPv4 aus.
Auf Grund der Spezifikation von DS-Lite
ist ein direkter Verbindungsaufbau
aus dem Internet
auf einen IPv4-Netzwerkadapter
im lokalen Netzwerk nicht möglich,
denn das sogenannte IPv4-Portforwarding,
das dies möglich machen würde,
ist schlichtweg nicht vorgesehen.
[[...]](https://de.wikipedia.org/wiki/IPv6#Dual-Stack_Lite_(DS-Lite))
Im Sinne der Datensparsamkeit ist dies unter Umständen sogar vorteilhaft.
Eine Firewall für eingehenden Datenverkehr muss nur für den IPv6-basierten
Teil des Internets konfiguriert werden.

Im weiteren Verlauf dieses Tutorials wird davon ausgegangen,
dass Kommunikation im lokalen Netzwerk per IPv4
und global (Internet) per IPv6 adressiert wird.

### Mobile Netzwerke und IPv6: Maus und Katz

Bei den Anbietern des mobilen Internets
steht die Welt quasi Kopf.
Vor allem günstige Hoster
bieten ausschließlich die IPv4 Adressierung der mobilen Geräte an.
Schnell wird klar,
dass eine direkte IPv4-basierte Verbindung
von einem mobilen Endgerät auf den lokalen Rechner
nicht ohne Hürden zu nehmen ist.

## Aufbau einer lösungsorientierten Infrastruktur

Ein gangbarer Weg,
die Wunschvorstellung mit wenig Aufwand zu erfüllen,
ist folgender:

**einen Mini-V-Server als IPv4/IPv6-Vermittler nutzen**
- ssh-Server (IPv4,IPv6)
- ssh-TCP-Forwarding auf RasPi

**lokalen Rechner als ssh-reverse-Client nutzen**
- IPv6 Adresse muss nicht öffentlich bekannt sein (DNS)
- Kommunikation erfolgt über 'localhost'
- ssh-psk: Privater Schlüssel bleibt 'zu Hause'

### Mini-V-Server mieten

Es gibt Hoster,
die sogenannte Mini-Server anbieten.
Das sind Virtuelle Maschinen mit durchschnittlich folgenden Rahmenbedingungen:

- **feste IPv4-Adresse**
- **feste IPv6-Adresse**
- **globale DNS-Zone für beide Adressen**
- **GNU/Linux Betriebssystem**
- **Zugriff per ssh**
- 10-12€ / Jahr
- 10 GByte Partition
- globales reverse DNS für beide Adressen
- kein VPN per TUN/TAP

Die wichtigsten Merkmale bezogen auf dieses Tutorial
sind **fett** hervorgehoben und sollten in jedem Fall vorhanden sein.

### Hardware/Software

Dieses Tutorial startet mit folgender Hardware und Software:

- Raspberry Pi mit Betriebssystem Raspberry Pi OS
- Mini-V-Server bei einem beliebigen Hoster
- 'Connect Box' eines bekannten Internetdienstleisters als DS-Lite Gateway

### Festlegungen

Synonyme und Definitionen:
- Raspberry Pi = RasPi = `raspi`
- Mini-V-Server = VServer = `vserver`

### Schritt für Schritt Anleitung
- auf einer Text-Konsole des RasPi als 'pi' einloggen
- einen Benutzer 'ssh-tunnel' auf dem RasPi anlegen und anmelden:
```
sudo adduser ssh-tunnel
su - ssh-tunnel
```
- ssh-psk des RasPi erzeugen:
```
ssh-keygen -t rsa -b 4096
```
- VServer per SSH connecten und gleichen Benutzer anlegen:
```
ssh root@vserver
adduser ssh-tunnel
exit
```
- öffentlichen Schlüssel des ssh-psk auf den VServer kopieren:
```
ssh-copy-id ssh-tunnel@vserver
```
- ssh-psk Verbindung testen:
```
ssh ssh-tunnel@vserver
```
- sshd - Konfiguration sichern und editieren:
```
su - root
cp /etc/ssh/sshd_config /etc/ssh/sshd_config~
nano /etc/ssh/sshd_config
```
- bestehende Konfiguration durch folgende ersetzen:
```
GatewayPorts clientspecified
ClientAliveInterval 180
ClientAliveCountMax 3
Subsystem sftp /usr/lib/openssh/sftp-server
AcceptEnv LANG
AcceptEnv LC_*
PrintMotd yes
PermitRootLogin no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
GSSAPIAuthentication no
HostbasedAuthentication no
KbdInteractiveAuthentication no
KerberosAuthentication no
PasswordAuthentication no
PubkeyAuthentication yes
UsePAM no
AllowUsers ssh-tunnel
```
- nano verlassen mit: [Strg]+[o] dann [Enter] dann [Strg]+[x]
- Konfiguration testen, neu einlesen, Session verlassen:
```
sudo sshd -t
sudo service sshd restart
exit
exit
```
- [Datei tunnel](https://github.com/ingank/Linux/blob/master/files/how2_dslite-ssh-jumpserver/tunnel) in das Verzeichnis /home/ssh-tunnel/ des RasPi herunterladen
- Datei öffnen und Quellcode erfassen

## Anwendung des SSH-Tunnels

Tunnel starten
```
./tunnel start server
```
Tunnel stoppen
```
./tunnel stop
```
Tunnelstatus anzeigen
```
./tunnel status
```
Tunnel neu starten
```
./tunnel restart server
```
weitere TCP-Forwarder definieren
```
-R :IN-PORT:[::1]:OUT-PORT \
```
aus dem Internet per ssh auf den RasPi einloggen
```
ssh pi@vserver -p 2222
```
