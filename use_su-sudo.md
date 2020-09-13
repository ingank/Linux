# su und sudo

* `su foo`
  * switch user oder substitute user
  * Deutsch: wechsle zum Benutzer foo
  * wenn kein foo, dann automatisch root
* `sudo bar`
  * super user do
  * Deutsch: führe das Programm `bar` als Superuser aus
  * der ausführende Benutzer muss in einer sudoers-Datei definiert sein

```
# Wechsle zum Benutzer root und führe die Datei /root/.bashrc aus:

su

# Wechsle zum Benutzer root und führe die Dateien /etc/profile, /root/.profile und /root/.bashrc aus:

su -

# Wechsle zum Benutzer root und führe die Datei /root/.bashrc aus,
# wenn dem derzeitigen Benutzer in einer sudoers-Datei die entsprechenden Rechte zugewiesen wurden:

sudo su

# Wechsle zum Benutzer root und führe die Dateien /etc/profile, /root/.profile und /root/.bashrc aus, 
# wenn dem derzeitigen Benutzer in einer sudoers-Datei die entsprechenden Rechte zugewiesen wurden:

sudo su -
```
### Quellen:
* https://ozsoyler.blogspot.com/2018/12/what-are-differences-of-susu-sudosudo.html
