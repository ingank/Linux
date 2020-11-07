# Verzögerter ssh-Login auf GNU/Linux

Ein Debian GNU/Linux ohne GUI startet direkt in den Konsolen-Mehrbenutzermodus.
Das System hat einen ssh-Dämonen an Bord, der beim Booten auch gestartet wird.
So weit so gut - es kann jedoch vorkommen,
dass ca. fünf Minuten vergehen,
bis der Login per ssh möglich ist.

## Inspektion

In den Logdateien */var/log/messages* und */varlog/syslog* ist nachzuvollziehen,
dass systemd den ssh-Server mehrmals versucht neu zu starten,
bis es dann nach folgendem Eintrag in beiden Dateien gelingt:
```
Jan 31 06:30:15 debian kernel: [  307.204523] random: crng init done
Jan 31 06:30:15 debian kernel: [  307.204527] random: 7 urandom warning(s) missed due to ratelimiting
```

Offensichtlich benötigt der Zufallszahlengenerator diese Zeit um seinen Zufallszahlenstamm zu füllen.
Wie dem auch sei - die Lösung für dieses Problem ist einfach:

## Löungsansatz
```
sudo apt install haveged
sudo systemctl enable haveged
sudo init 6
```

## Quellen
```
* https://www.linuxquestions.org/questions/debian-26/debian-hangs-at-boot-with-random-crng-init-done-4175613405
* https://www.linux-magazin.de/ausgaben/2011/09/einfuehrung2
```