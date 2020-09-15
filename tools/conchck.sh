#!/bin/bash

# conchck.sh
# Ein Tool zur Inspektion der Netzwerkkonnektivität eines Linux-Systems
#
# greift die Diskussion unter
# https://unix.stackexchange.com/questions/190513/shell-scripting-proper-way-to-check-for-internet-connectivity
# auf und versucht die Vorschläge in einfachen Code umzusetzen
#
# ACHTUNG: Dieses Programm ist ein erster Entwurf und wurde nicht ausreichend getestet.
#
# TODO
# Namensauflösung externer Ressourcen?
# http?
# https?
# ntp?

echo "PINGv4 -> Internet ?"
if ping -q -c 1 -W 1 8.8.8.8; then
  echo "PINGv4 -> Internet [OK]"
else
  echo "PINGv4 -> Internet [NICHT-OK]"
fi

if ping -6 -q -c 1 -W 1 2001:4860:4860::8888 >/dev/null; then
  echo "PINGv6 -> Internet [OK]"
else
  echo "PINGv6 -> Internet [NICHT-OK]"
fi

if dig +timeout=1 +retry=1 >/dev/null; then
  echo "DNS-Server aus /etc/resolv.conf erreichbar [JA]"
else
  echo "DNS-Server aus /etc/resolv.conf erreichbar [NEIN]"
fi
