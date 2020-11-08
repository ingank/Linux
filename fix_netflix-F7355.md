# Netflix F7355 Error mit Firefox@Ubuntu

Wer auf einem Ubuntu 19.10 mit Firefox in der Standardkonfigurarion Netflix-Videos anschauen möchte,
wird mit dem Fehler F7355 davon abgehalten.

## Fix

Nach der Installation des folgenden Codecs sollten Netflix-Videos abgespielt werden können:
```
sudo apt-get install libavcodec-dev
```
