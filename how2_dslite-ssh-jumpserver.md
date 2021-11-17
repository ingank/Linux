# DS-Lite: IPv4 Income per SSH-Jumpserver

## Aufgabenstellung

Stellen Sie sich folgendes Szenario vor:

zu Hause:
- GNU/Linux auf einem Raspberry Pi im lokalen Netzwerk
- Internetzugang per DS-Lite Gateway (IPv4 OUT / IPv6 IN/OUT)

Mobil:
- Android auf einem mobilen Gerät (Smartphone, Tablet)
- Internetzugang per IPv4 basiertem mobilen Internet

Wunsch:
- Ich möchte (im ersten Step) von meinem mobilen Gerät per ssh auf den Raspberry Pi zugreifen.

## Diagnose

Welche technischen Fallstricke stehen einer schnellen Erfüllung des oben genannten Wunsches im Wege?

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
ist schlichtweg nicht vorgesehen. [[...]](https://de.wikipedia.org/wiki/IPv6#Dual-Stack_Lite_(DS-Lite))

Was erst einmal wie ein riesiger Nachteil aussieht,
ist bei näherer Betrachtung durchaus auch vorteilhaft.
Ein lokales IPv4 Netzwerk ist von außen nicht erreichbar.
Wer also ein lokales IPv4 basiertes Netzwerk betreibt,
muss sich um dessen eingehenden Netzwerkverkehr
im Sinne der Netzwerksicherheit keine Gedanken machen;
es gibt ihn einfach nicht.
Im weiteren Verlauf dieses Tutorials wird davon ausgegangen,
dass Kommunikation im lokalen Netzwerk per IPv4
und global (Internet) per IPv6 adressiert wird.

### Mobile Netzwerke und IPv6: Maus und Katz

Bei den Anbietern des mobilen Internets steht die Welt quasi Kopf.
Vor allem günstige Hoster bieten ausschließlich die IPv4 Adressierung an.
Schnell wird klar:

### Das passt nicht!

"Guck in den Ofen" - Matrix:
|Gerät|IPv4 IN CONN|IPv6 IN CONN|IPv4 OUT CONN|IPv6 IN CONN|
|-|:-:|:-:|:-:|:-:|
|Mobil| x | - | **(x)** | - |
|RasPi| **(-)** | x | x | x |

Damit die Verbindung ohne Modifikationen aufgebaut werden kann,
müssten beide Klammern ein 'x' enthalten.

## Aufbau einer lösungsorientierten Infrastruktur

Ein gangbarer Weg, die Aufgabenstellung mit wenig Aufwand zu erfüllen wäre folgender:

- einen Mini-V-Server als IPv4/IPv6-Vermittler nutzen
  - ssh-Server (IPv4,IPv6)
  - ssh-Forwarder auf RasPi
  - TCP-Portforwarding auf RasPi
  - DNS-Zone als 'kostenlose' Beigabe

- RasPi als ssh-Client
  - IPv6 Adresse muss nicht bekannt sein
  - jeglicher INCOMMING TRAFFIC kann geblockt werden
  - ssh-psk: Privater Schlüssel bleibt 'zu Hause'

### Mini-V-Server mieten

Es gibt Hoster,
die sogenannte Mini-Server anbieten.
Das sind Virtuelle Maschinen mit durchschnittlich folgenden Rahmenbedingungen:

- 10-12€ / Jahr
- 10 GByte Partition
- **feste IPv4-Adresse**
- **feste IPv6-Adresse**
- globale **DNS-Zone für beide Adressen**
- globales reverse DNS für beide Adressen
- GNU/Linux Betriebssystem
- **Zugriff per ssh**
- **kein** VPN per **TUN/TAP**

Die wichtigsten Merkmale bezogen auf dieses Tutorial sind **fett** hervorgehoben.


### ssh-Tunneling anstatt VPN

In dieser Preisklasse an gehosteten V-Servern
ist für gewöhnlich die Einrichtung eines Tunnel-Interfaces (TUN/TAP) nicht vorgesehen,
womit der Aufbau eines VPN's,
was wohl sehr naheliegend wäre,
ersteinmal ausgeschlossen werden kann.

Wie sooft,
kann diese Schwäche zu einer Stärke gereichen:
Warum sollen wir ein VPN aufbauen,
dass (mit heißer Nadel konfiguriert) mehr Scheunentore ins lokale Netzwerk öffnet,
als der Nutzen jemals rechtfertigen könnte.

Denn was benötigen wir wirklich?
- einen ssh-Zugriff auf den RaspPi
- über den dann in diesem Stadium auch sftp sofort möglich wäre
- zusätzliche Dienste sollten nach dem Baukastenprinzip hinzugefügt werden können

Baukastenprinzip:
- ein TCP-Dienst bekommt einen ssh-Tunnel zugewiesen

Vorteil:
- volle Kontrolle über den Eintrittspunkt in das lokale Netzwerk

### reverse-Tunnel anstatt forward-Tunnel

Wie wird im Allgemeinen mit ssh gearbeitet?
Ich möchte lokal etwas entfernt (remote) erledigen.
Ich logge mich mit einem ssh-Klienten auf einem ssh-Server ein und behalte diese Richtung bei meiner Arbeit bei.
Tunnel werden **auch** in diese Richtung etabliert.

Diese Logik bedeutet für die hiesige Problemstellung jedoch einen Mehraufwand für den Einrichter.
Die globale IPv6-Adresse des RaspPi müsste dem Client bekannt sein.
Diese kann sich laut IPv6 Spezifikation jedoch ändern und müsste dann sich jedoch in 
Natürlich könnte diese Aufgabe ein dynDNSv6 Dienst übernehmen,
doch es gibt eine elegantere Lösung, nämlich reverse-ssh-Tunnel.

Diese werden von einem ssh-Server in Richtung ssh-Client etabliert.
Wenn der RaspPi einen solchen Tunnel zum V-Server aufbaut,
dann muss die dynamisch erzeugte,
globale und bestenfalls anonymisierte IPv6 des RaspPi nicht öffentlich bekannt sein.
Dies fördert duchaus die Sicherheit durch das Prinzip der Datensparsamkeit.

## Praxisteil

Wer direkt mit der praktischen Umsetzung beginnen möchte, ist hier genau richtig.

### V-Server hosten

Der V-Server des Hosters seiner Wahl sollte mindestens folgendes bieten:

- GNU/Linux
- feste IPv4-Adresse
- feste IPv6-Adresse
- globale DNS-Zone für beide Adressen
- Zugriff per ssh (priviligierter Nutzer / Passwort)
