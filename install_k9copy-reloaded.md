# k9copy-reloaded auf Ubuntu 18.04 installieren
'k9copy-reloaded' ist ein DVD-Ripper, der eine Linux-Alternative zum unter Windows gebräuchlichen 'DVD shrink' darstellen soll.
```
wget http://tomtomtom.org/k9copy-reloaded/k9copy_3.0.3-1~deb9u1_amd64.deb
sudo dpkg -i k9copy_3.0.3-1~deb9u1_amd64.deb
```
Die angezeigten __Fehlermeldungen ignorieren__!
```
sudo apt --fix-broken install
sudo dpkg -i k9copy_3.0.3-1~deb9u1_amd64.deb
```
Damit die Icons im Anwendungsmenü klickbar werden:
```
sudo sed -i_bak 's|Exec=k9copy -caption|Exec=k9copy|' /usr/share/applications/k9copy.desktop
sudo sed -i_bak 's|Exec=k9copy --assistant -caption|Exec=k9copy --assistant|' /usr/share/applications/k9copy_assistant.desktop
```
