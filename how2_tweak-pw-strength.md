# Passwortregeln anpassen

Öffne Datei:
```
/etc/pam.d/common-password
```

Suche Zeile:
```
password	[success=1 default=ignore]	pam_unix.so obscure sha512
```

Ändere Zeile in:
```
password	[success=1 default=ignore]	pam_unix.so minlen=1 sha512
```
Nach dieser Anpassung können Passwörter ohne Regelverstoß geändert werden.
