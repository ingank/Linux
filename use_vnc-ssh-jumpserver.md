# VNC über SSH-Jumpserver
```
Setup:
- VNC-Server auf einem RPi hinter einer IPv6-Firewall (No-incomming-connections)
- VNC-Client auf PC mit Ubuntu hinter einer IPv6-Firewall (No-incomming-connections)
- öffentlicher Virtual Server mit ssh-Zugang
```
## Konfiguration RPi

* VNC-Server aktivieren
  * `raspi-config`
  * Menü 5/P3/YES

* VNC-Server konfigurieren
  * vnc-connect öffnen
  * Drei Striche // Options...
  * Security // Encryption = "Always on"
  * Connections // Filter direct connections
    * Standardfilter "reject"
    * Add rule // Adresse: "::1" // Accept connection

## Konfiguration Ubuntu-PC
* VNC-Viewer installieren

## Konfiguration Virtual Server
* Benutzer "vnc" einrichten
* RPi und Ubuntu-PC den ZUgriff per ssh ermöglichen

## Reverse-ssh-Tunnel vom RPi aus erzeugen
```
ssh -v -R [::1]:5900:[::1]:5900 vnc@virtual.server
```
## Forwarding-ssh-Tunnel vom Ubuntu-PC aus erzeugen
```
ssh -v -L [::1]:5900:[::1]:5900 vnc@virtual.server
```
