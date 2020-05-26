# SSH Public Key Authentifizierung

Wird ssh (sowohl Client als auch Server) in der Grundkonfiguration betrieben,
muss bei jeder neuen ssh-Session das Passwort des Benutzers auf dem entfernten Rechner eingegeben werden.
Das muss aber nicht so sein, ssh bietet eine komfortable Lösung an, die SSH Public Key Authentifizierung.

## Clientseitige Voraussetzungen

### RSA-Schlüsselpaar erzeugen

Auf dem ssh-Client-Rechner muss ein RSA-Schlüsselpaar vorhanden sein.
Dieses befindet sich im Regelfall in den Dateien ~/.ssh/id_rsa (privater Schlüssel aka private_key)
und ~/.ssh/id_rsa.pub (Öffentlicher Schlüssel aka public_key).
Ein einmal erzeugtes Schlüsselpaar kann für viele verschiedene PKA-basierte ssh-Verbindungen genutzt werden,
nicht nur für eine bestimmte.

Wenn noch kein Schlüsselpaar auf dem Clientrechner vorhanden ist, kann es einfachst erzeugt werden:
```
ssh-keygen -t rsa -b 4096
```

### Privater Schlüssel

Der private Schlüssel (private_key) sollte beim Erzeugen des Schlüsselpaares im folgenden Dialog:
```
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```
... mit einer geheimen Passphrase verschlüsselt werden.
So ist sicher gestellt,
dass bei fremdem Zugriff auf das lokale Nutzerkonto,
der private Schlüssel geschützt bleibt.
Wer hier eine Passphrase eingibt,
schließt quasi seinen privaten PKA-Schlüssel in eine Kassette
und steckt den Schlüssel für die Kassette in seinen Kopf.

An dieser Sicherheitsmaßnahme kann man leidlich erkennen,
dass der private Schlüssel auch privat bleiben sollte.
Wurde er kompromitiert,
d.h. ein unverschlüsseltes Exemplar kopiert,
dann sind alle ssh-Zugänge,
die den öffentlichen Schlüssel des gleichen Schlüsselpaares akzeptieren,
potentiell gefährdet.
Nun, soweit kommt es natürlich nicht;
wir verschlüsseln unseren privaten Schlüssel wie oben empfohlen :)

### Öffentlicher Schlüssel

Mit dem öffentlichen Schlüssel verhält es sich anders.
Er kann ohne Bedenken kopiert und weitergegeben werden.

## Serverseitige Voraussetzungen

Die Bekanntgabe des öffentlichen Schlüssel gegenüber dem ssh-Server erfolgt mit folgendem Befehl auf dem Client:
```
ssh-copy-id benutzer@entfernter.rechner
```
Es wird (ein letztes Mal) das Passwort für den entfernten Benutzer-Login abgefragt.
Nach erfolgreicher Übermittlung des Schlüssels sollte folgende Meldung ausgegeben werden:
```
Now try logging into the machine, with: "ssh 'benutzer@entfernter.rechner'"
and check to make sure that only the key(s) you wanted were added.
```
Der Aufforderung kann gefolgt werden:
```
ssh benutzer@entfernter.rechner
```

## SSH-Agent

An dieser Stelle öffnet der lokale SSH-Agent einen Dialog zur Abfrage der zur Verschlüsselung genutzten Passphrase.
Dieser Dialog kann entweder textbasiert:
```
Enter passphrase for key '/home/benutzer/.ssh/id_rsa':
```
oder grafikbasiert ausgeführt sein.
Nach Eingabe der korrekten Passphrase übernimmt der ssh-agent die Authentifizierung
dieser und aller weiteren ssh-Sessions (auch zu anderen Servern).
Voraussetzung ist nur, dass sie Gegensstelle den passenden öffentlichen Schlüssel kennt und akzeptiert.

## Öffentliche SSH-Schlüssel zentral verwalten und nutzen

Die APIs der Quellcode-Hoster https://launchpad.net und https://github.com
ermöglichen es, auf die hinterlegten öffentlichen SSH-Schlüssel von Nutzern
zuzugreifen.
Mit Hilfe eines Einzeilers in einem Linux-Terminal kann einem solchen Nutzer
der Zugriff per ssh auf den Login des aktuellen Linux-Users der aktuellen Maschine
gewährt werden:
```
$ ssh-import-id-lp lp-user   # Launchpad
$ ssh-import-id-gh gh-user   # GitHub
```
Die abgerufenen öffentlichen Schlüssel werden in der Datei
~/.ssh/autorized_keys hinerlegt und können mit einem beliebigen Texteditor
im Nachhinein ausgedünnt werden. Das ist beispielweise dann angeraten, wenn
nur von einem speziellen Rechner aus der Zugriff gewährt werden soll.

### Launchpad Schlüsselverwaltung

* Nutzer anlegen:      https://login.ubuntu.com/+login
* Schlüssel verwalten: https://login.ubuntu.com/ssh-keys

### GitHub Schlüsselverwaltung

* Nutzer anlegen:      https://github.com
* Schlüssel verwalten: https://github.com/settings/keys
