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

if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  echo "PINGv4 -> Internet [JA]"
else
  echo "PINGv4 -> Internet [NEIN]"
fi

if ping -6 -q -c 1 -W 1 2001:4860:4860::8888 >/dev/null; then
  echo "PINGv6 -> Internet [JA]"
else
  echo "PINGv6 -> Internet [NEIN]"
fi

if dig +timeout=1 +retry=1 >/dev/null; then
  echo "DNS-Server aus /etc/resolv.conf erreichbar [JA]"
else
  echo "DNS-Server aus /etc/resolv.conf erreichbar [NEIN]"
fi
