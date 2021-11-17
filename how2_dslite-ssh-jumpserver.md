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
|mobiles Endgerät| x | - | __(x)__ | - |
|zu Hause| __(-)__ | x | x | x |

Damit die Verbindung ohne Modifikationen aufgebaut werden kann,
müssten beide Klammern ein 'x' enthalten.

### dynDNSv6 - nur die halbe Miete

Eine dynamisch erzeugte globale IPv6-Adresse auf dem RaspPi könnte per dynDNSv6 einem DNS-Hoster bekannt gegeben werden.
So wäre er von einem beliebigen Rechner im Internet mit einem Klartextnamen zu erreichen.
Da nichtdestotrotz weiterhin das Problem der kollidierenden IP-Versionen zwischen Mobilgerät und DS-Lite besteht,
erzeugt die Umsetzung eher zusätzlichen Aufwand als Nutzen.

### Öffentlicher Virtueller Server als IPv4/6-Vermittler

Es gibt Hoster, die sogenannte Mini-Server anbieten.
Das sind Virtuelle Maschinen mit durchschnittlich folgenden Rahmenbedingungen:

- Kosten: 10-12€ / Jahr
- 10 GByte Partition
- **feste IPv4-Adresse**
- **feste IPv6-Adresse**
- globale **DNS-Zone für beide Adressen**
- globales reverse DNS für beide Adressen
- Unterschiedliche Linuxdistros zur Auswahl
- **Zugriff per ssh**

Wichtigste Merkmale für dieses Projekt sind die beiden festen IP-Adressen in Version 4 und 6,
sowie die jeweilige Domainnamenäuflösung und der ssh-Zugang.
Mit diesen Komponenten können beide Geräteparks bedient werden:
sowohl gloabe IPv6-Adressen von Geräten im lokalen Netzwerk als auch mobile Geräte im ausschließlichen IPv4-Internet.

### ssh-Tunneling anstatt VPN

In dieser Preisklasse an gehosteten Servern wird gewöhnlich **kein** TUN/TAP-Interface angeboten,
womit der Aufbau eines VPN's, was wohl naheliegend wäre, ersteinmal ausgeschlossen werden kann.

Wie sooft, kann eine Schwäche aber zu einer Stärke gereichen:
Wieso ein VPN aufbauen, dass mit heißer Nadel konfiguriert mehr Scheunentore ins lokale Netzwerk öffnet,
als der Nutzen jemals rechtfertigen könnte.

Denn was benötigen wir für den Anfang an Konnektivität?
Vielleicht einen ssh-Zugriff auf den RaspPi,
über den auch sftp möglich ist.
Zusätzliche Dienste sollten nach dem Baukastenprinzip hinzugefügt werden können.
Diese Vorgaben können alle durch ssh mittels Port-Tunneling
(hier vergleichbar mit sicherem Portforawarding)
selbst erfüllt werden.

Neue Dienste bekommen im einfachsten Falle neue ssh-Tunnel zugewiesen.
Vorteil: Der Einrichter des jeweiligen Tunnels hat stets die volle Kontrolle über den Eintrittspunkt in das lokale Netzwerk.

### Oh mein Gott, da gibt's doch diese *reverse-ssh-Tunnel*, oder?

Wie wird im Allgemeinen mit ssh gearbeitet?
Ich möchte lokal etwas entfernt (remote) erledigen.
Ich logge mich mit einem ssh-Klienten auf einem ssh-Server ein und behalte diese Richtung bei meiner Arbeit bei.

Diese Logik bedeutet für die hiesige Problemstellung jedoch einen Mehraufwand für den Einrichter.
Die globale IPv6-Adresse des RaspPi müsste dem Client bekannt sein.
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
