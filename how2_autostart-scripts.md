# Skripte automatisch ausführen

Dieser Artikel beschreibt verschiedene Möglichkeiten,
eigene Skripte automatisiert ausführen zu lassen.

## Bootskripte

Bootskripte werden durch den Kommandozeileninterpreter während des Bootens ausgeführt.
Der Bootprozess beginnt mit dem Laden des Bootloaders und endet mit der ersten möglichen Benutzerinteraktion.

## Loginskripte

Loginskripte werden automatisch bei einem Konsolen-Login ausgeführt.
Konsole ist hier ein Oberbegriff für alle auf dem System vorhandenen Benutzerschnittstellen,
sei sie nun textbasiert oder grafisch ausgeführt.

## Cronjobs

Cronjobs sind zeitlich getaktete Aufträge,
die Skripte starten können.

## Anacronjobs

Anacronjobs sind zeitlich getaktete Aufträge,
die beim Verpassen des letzten Triggers sofort ausgeführt werden.
Dieses Verhalten ist beispielsweise bei nicht immer laufenden Rechnern erwünscht.

## Links

* https://transang.me/create-startup-scripts-in-ubuntu/
* https://debian-handbook.info/browse/de-DE/stable/sect.task-scheduling-cron-atd.html
* https://debian-handbook.info/browse/de-DE/stable/sect.asynchronous-task-scheduling-anacron.html
* https://www.tecmint.com/auto-execute-linux-scripts-during-reboot-or-startup/
