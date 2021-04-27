# Zeitdifferenz zischen Linux und Windows auf einem Rechner auflösen

```
timedatectl set-local-rtc 1 --adjust-system-clock
```
Prüfen der Einstellung:
```
timedatectl | grep 'RTC in local TZ'
>> RTC in local TZ: yes
```
Einstellungen rückgängig machen:
```
timedatectl set-local-rtc 0 --adjust-system-clock
```
