# GRUB Version 2.06 kompilieren

Abhängigkeiten auflösen:
```
sudo apt update
sudo apt install make binutils bison gcc gettext flex
```
Quellen laden und prüfen:
```
curl -O ftp.gnu.org/gnu/grub/grub-2.06.tar.gz
curl -O ftp.gnu.org/gnu/grub/grub-2.06.tar.gz.sig
gpg --keyserver keyserver.ubuntu.com --receive-keys BE5C23209ACDDACEB20DB0A28C8189F1988C2166
gpg --verify grub-2.06.tar.gz.sig
```
Überprüfung OK:
```
gpg: assuming signed data in 'grub-2.06.tar.gz'
gpg: Signature made Tue 08 Jun 2021 05:11:03 PM CEST
gpg:                using RSA key BE5C23209ACDDACEB20DB0A28C8189F1988C2166
gpg: Good signature from "Daniel Kiper <dkiper@net-space.pl>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: BE5C 2320 9ACD DACE B20D  B0A2 8C81 89F1 988C 2166
```
Entpacken:
```
tar -xvzf grub-2.06.tar.gz
```
Kompilieren:
```
cd grub-2.06
./configure
./make
```
Installieren:
```
sudo make install
```
