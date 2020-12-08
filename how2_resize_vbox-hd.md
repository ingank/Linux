# Virtuelle Festplatten (Virtual Box) nachträglich vergrößern

Virtuelle Maschinen auflisten:
```
VBoxManage list vms
# "Ubuntu" {7438760b-a968-4d02-8450-df3061a9af6a}
```

Die in der VM verwendeten Festplatten auflisten:
```
VBoxManage showvminfo 7438760b-a968-4d02-8450-df3061a9af6a | grep 'UUID:'
# UUID:                        7438760b-a968-4d02-8450-df3061a9af6a
# Hardware UUID:               7438760b-a968-4d02-8450-df3061a9af6a
# SATA (0, 0): /foo/bar/Ubuntu.vdi (UUID: c192491c-d2a4-42c7-a201-ca219f6c8030)
```

Derzeitige Größe der SATA-Festplatte feststellen:
```
VBoxManage showmediuminfo c192491c-d2a4-42c7-a201-ca219f6c8030 | grep Capacity
# Capacity:       256000 MBytes
```

Die Festplatte (virtuelle Hardware) um 100% vergrößern:
```
VBoxManage modifyhd --resize 512000 c192491c-d2a4-42c7-a201-ca219f6c8030
# 0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
```

**Hinweis:** Damit das installierte Betriebssystem auch mit dem Mehr an Kapazität etwas anfangen kann,
müssen die letzte Partition vergrößert oder zusätzliche Partitionen hinzugefügt werden.
