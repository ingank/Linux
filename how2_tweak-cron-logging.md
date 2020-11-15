# Das Logging von cron-Jobs steuern

Viele parallele oder schnell wiederkehrende cron-Jobs können in der Standardeinstellung diverser Linux-Distributionen die Lesbarkeit von */var/log/syslog* herabsetzen. Dieser Artikel befasst sich mit dem Handling dieses Verhaltens.

## Möglichkeit 1 : Ausgabe filtern

Die wohl einfachste Möglichkeit ist,
bei der Anzeige der Log-Datei die entsprechenden Zeilen einfach auszublenden.
```
sudo cat /var/log/syslog | grep -v CRON
```

Der Nachteil dieser Methode ist, dass die Logdatei vor allem bei vielen CRON-Einträgen trotzdem schnell größer wird.

## Möglichkeit 2 : Cron-Jobs nicht loggen

Der Cron-Deamon loggt in der Grundeinstellung seine Tätigkeiten mit.
Dass er das unterlassen soll, kann ihm direkt mitgeteilt werden:
```
echo 'EXTRA_OPTS=-L 0' | sudo tee /etc/default/cron
```

## Möglichkeit 3 : Logging umleiten

Der cron-Deamon übergibt seinen Logging-Stream an den rsyslog-Deamon.

Soll die Ausgabe des cron-log-Streams in eine andere Datei als */var/log/syslog* erfolgen,
kann dies dem rsyslog-Deamon über seine Konfigurationsdatei mitgeteilt werden:
```
sudo nano /etc/rsyslog.conf
```
In dieser Datei ist die separate Logdatei per default deaktiviert:
```
#cron.*				/var/log/cron.log
```
Diese Zeile muss auskommentiert werden:
```
cron.*				/var/log/cron.log
```

Desweiteren kann auch dieser Logging-Stream per Log-Rotate vor dem *Überlaufen* geschützt werden:
```
sudo nano /etc/logrotate.d/rsyslog
```
In folgendem Block sollte wie dargestellt die Datei */var/log/cron.log* auch aufgeführt sein:

```
/var/log/mail.info
/var/log/mail.warn
/var/log/mail.err
/var/log/mail.log
/var/log/daemon.log
/var/log/kern.log
/var/log/auth.log
/var/log/user.log
/var/log/lpr.log
/var/log/cron.log
/var/log/debug
/var/log/messages
{
	rotate 4
	weekly
	missingok
	notifempty
	compress
	delaycompress
	sharedscripts
	postrotate
		/usr/lib/rsyslog/rsyslog-rotate
	endscript
}
```

Abschließend muss der rsyslogd-Dämon neu gestartet werden:
```
sudo /etc/init.d/rsyslog force-reload
[ ok ] Reloading rsyslog configuration (via systemctl): rsyslog.service.
```
