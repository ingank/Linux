# Mails mit ssmtp versenden

ssmtp is a send-only sendmail emulator for machines which normally pick their mail up from a centralized mailhub (via pop, imap, nfs mounts or other means).
It provides the functionality required for humans and programs to send mail via the standard or /usr/bin/mail user agents.

```
# Als Benutzer mit root-Rechten werden folgende Tätigkeiten ausgeführt:

apt update
apt upgrade
apt install ssmtp mailutils


# Die Datei /etc/ssmtp/ssmtp.conf wird bearbeitet:

nano /etc/ssmtp/ssmtp.conf

# Folgende Einträge sollten vorhanden sein für eine SSL/TLS-Authentifizierung:

mailhub=smtp.server:port
hostname=computer
UseTLS=yes
AuthMethod=cram-md5
AuthUser=User
AuthPass=Passphrase
```
