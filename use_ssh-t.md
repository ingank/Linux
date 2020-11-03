# Terminal-Befehle per SSH unmittelbar auf dem Zielhost ausführen

Dem Kommando ssh kann ein auf dem Zielhost auszuführender Befehl als Argument übergeben werden.
```
ssh user@host -t command
```

Beispiel:
```
ssh user@host -t df
Dateisystem       1K-Blöcke Benutzt Verfügbar Verw% Eingehängt auf
/dev/loop         105756448  858252  99586712    1% /
none                4194304       0   4194304    0% /sys/fs/cgroup
none                4194304       0   4194304    0% /dev
tmpfs               4194304       0   4194304    0% /dev/shm
tmpfs               4194304    1108   4193196    1% /run
tmpfs                  5120       0      5120    0% /run/lock
none                4194304       0   4194304    0% /run/shm
Connection to host closed.
```

Mehrere Befehle nacheinander ausführen:
```
ssh user@host -t command1 && command2 && command3
```

Der Remote-Befehl kann auch als *sudo* ausgeführt werden.
Dazu wird die nötige Passphrase mit Hilfe des Befehls 'echo' über eine Pipe an den Befehl 'sudo' übermittelt.
Diese Art der entfernten Ausführung sollte aus Sicherheitsgründen **NICHT** in Skripten Verwendung finden.
```
ssh user@host -t echo passphrase | sudo --stdin apt-get update
```
