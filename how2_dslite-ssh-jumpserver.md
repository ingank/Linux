# DS-Lite: Portforwarding über SSH-Jumpserver

Stellen Sie sich vor, Sie hätten folgende Komponenten:

- Internet lokal angebunden per DS-Lite Gateway
- Raspbian 10 auf RaspberryPi3B im lokalen Netzwerk
- Android Smartphone in einem IPv4 basierten mobilen Netz

... und möchten vom Smartphone aus per ssh-App auf den RaspberryPi zugreifen.

Kein Problem, denkt sich der Freizeitnetzwerker. Doch wie sooft: Der Teufel steckt im Detail.

Dieses Tutorial soll die Fallstricke und Sackgassen aufzeigen und am Ende zu einer einfach zu managenden Lösung verhelfen.
Eines sei jedoch gleich vorweg genommen: ganz für lau ist das unter Umständen nicht zu haben.
Warum das so ist und wie der Kosten-Nutzen-Faktor trotzdem gedeihlich gestaltet werden kann,
das ist der Kern dieses Projekts.

## Theorie

DS-Lite hat einen entscheidenden Vorteil: der interessierte Nutzer muss sich zwangsläufig mit IPv6 auseinandersetzen.
Wer beispielsweise einen Mini-Rechner wie den RaspberryPi aus dem Internet aus erreichbar machen will,
muss vorher einige Überlegungen anstellen.

### DSLite und IPv4: Katz und Maus

Grundsätzlich sind alle Rechner des lokalen Netzwerkes *hinter* einem DS-Lite-Gateway auch direkt aus dem Internet erreichbar.
Noch besser: sie sind Teil des routbaren Internets.
Einschränkung: Diese Aussage bezieht sich auf den mit IPv6 addressierten Bereich.

Ganz anders sieht es bei IPv4 aus:
Auf Grund der Spezifikation von DS-Lite ist ein direkter Verbindungsaufbau
aus dem Internet auf einen IPv4-Netzwerkadapter im lokalen Netzwerk nicht möglich.
IPv4-Portforwarding ist nicht vorgesehen.

Was erst einmal wie ein großer Nachteil aussieht,
ist bei näherer Betrachtung durchaus auch vorteilhaft:
ein lokales IPv4 Netzwerk ist von außen physikalisch und damit auch logisch nicht erreichbar.
Im weiteren Verlauf dieses Dokuments wird davon ausgegangen,
dass Kommunikation im lokalen Netzwerk per IPv4 und global per IPv6 adressiert wird.

### Mobile Netzwerke und IPv6: Maus und Katz

Der Gedanke, sich von einem Smartphone (mit günstigem Mobilfunkanbieter)
direkt per ssh mit dem RaspPi zu verbinden scheitert in zweifacher Hinsicht:

1. Per IPv4 könnte zwar das mobile Endgerät verbinden, hingegen DS-Lite schiebt hier den Riegel vor.
2. Per IPv6 ist zwar der RaspPi direkt erreichbar - das kann jedoch unser Smartphone nicht.

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
