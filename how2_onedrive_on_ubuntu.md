# Microsoft OneDrive in Ubuntu nutzen

Die Gnome-Benutzeroberfläche eines aktuellen Ubuntu (Version 20.04 LTS) suggeriert,
dass mit Hilfe des Verwaltungtools _Online Accounts_ ein vorhandener _OneDrive_ eines Microsoft Accounts synchronisiert werden kann. Dem ist leider nicht so: Nach der erfolgreichen Anmeldung am Microsoft Account passiert genau: garnichts.

Linux wäre nicht Linux, wenn es nicht schon längst ein adäquates (Kommandozeilen-) Tool für diese Aufgabe gäbe. Dieses kleine Tutorial begleitet meine Erfahrungen bei der Installation und Nutzung von _rclone_.

## Installation

Auf der [Homepage des Projektes rclone](https://rclone.org/https://rclone.org/) ist der Installationsvorgang für die aktuell angesagten Betriebssysteme beschrieben. Für Ubuntu 20.04 LTS hat sich folgendendes bewährt:

Auf der Konsole als Benutzer mit erweiterten Rechten ausführen:
```
sudo apt install curl
curl https://rclone.org/install.sh | sudo bash
```
Das Installationsscript meldet die erfolgreiche Installation:
```
rclone v1.54.0 has successfully installed.
Now run "rclone config" for setup. Check https://rclone.org/docs/ for more details.
```

## Konfiguration

Wie das Installationsscript oben vorschlug, kann direkt mit der Konfiguration begonnen werden:
```
rclone config
```

Benutzergeführte Einrichtung des ersten Microsoft OneDrive Kontos:
```
No remotes found - make a new one
n) New remote
s) Set configuration password
q) Quit config
n/s/q> n[↵]
name> remote
Type of storage to configure.
Enter a string value. Press Enter for the default ("").
Storage> onedrive[↵]
OAuth Client Id
Leave blank normally.
Enter a string value. Press Enter for the default ("").
client_id> [↵]
OAuth Client Secret
Leave blank normally.
Enter a string value. Press Enter for the default ("").
client_secret> [↵]
Choose national cloud region for OneDrive.
Enter a string value. Press Enter for the default ("global").
region> [↵]
Edit advanced config? (y/n)
y) Yes
n) No (default)
y/n> [↵]
Remote config
Use auto config?
 * Say Y if not sure
 * Say N if you are working on a remote or headless machine
y) Yes (default)
n) No
y/n> [↵]
Log in and authorize rclone for access
Waiting for code...
```
Im sich öffnenden Webbrowser wird der Zugriff von _rclone_ auf OneDrive per Acces Token autorisiert.
Sobald der Prozess abgeschlossen wurde, kann die Konfiguration auf der Konsole fortgesetzt werden:
```
Got code
Choose a number from below, or type in an existing value
Your choice> onedrive[↵]
Found 1 drives, please select the one you want to use:
0:  (personal) id=0123456789abcdef
Chose drive to use:> 0[↵]
Found drive 'root' of type 'personal', URL: https://onedrive.live.com/?cid=0123456789abcdef
Is that okay?
y) Yes (default)
n) No
y/n> [↵]
--------------------
[remote]
type = onedrive
token = {"access_token":"..."}
drive_id = 0123456789abcdef
drive_type = personal
--------------------
y) Yes this is OK (default)
e) Edit this remote
d) Delete this remote
y/e/d> [↵]
Current remotes:

Name                 Type
====                 ====
remote               onedrive

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> q
```

Der OneDrive-Zugriff wurde konfiguriert. Ein erster Test zeigt das Hauptverzeichnis auf OneDrive:
```
rclone lsd remote:[↵]
          -1 2021-03-01 23:45:17         2 ID
          -1 2021-03-01 23:45:22         1 IT
          -1 2021-03-02 23:42:49         6 PDF
```

## OneDrive lokal mounten

Mountpoint erzeugen:
```
mkdir ~/OneDrive
```

OneDrive per FUSE mounten:
```
rclone mount remote: ~/OneDrive --vfs-cache-mode full
```

## Anmerkungen

* Es hat sich als vorteilhaft erwiesen, _OneDrive_ nur für die Dauer der gewünschten Bearbeitung zu mounten.
* Während der lokalen Arbeit an den _OneDrive_ - Dateien sollte nicht anderweitig, beispielsweise über die Weboberfläche schreibend auf OneDrive zugegriffen werden.
* Nach der Bearbeitung der Dateien wird _rclone_ mit `[Ctrl]+[C]` beendet.


## Quellen

* https://rclone.org/
* https://rclone.org/install/