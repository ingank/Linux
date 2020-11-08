# WeeChat aus den Quellen installieren

Der beliebte Chat-Client WeeChat kann in seiner Entwicklerversion
tagesaktuell aus den Quellen installiert werden.
Das Online-Benutzerhandbuch beschreibt detailliert den Build-Prozess.

Leider kann es aktuell noch vorkommen,
dass der Build-Prozess mit den voreingestellten Optionen abbricht. 

Das folgende Mini-Howto beschreibt in Kürze
die Installation auf einem aktuellen Debian GNU/Linux und seinen Derivaten.

## Abhängigkeiten auflösen
```
sudo apt-get build-dep weechat
```

## Quellcode downloaden
```
git clone https://github.com/weechat/weechat.git
```

## Build
```
cd weechat

mkdir build

cd build

cmake .. \
 -DCMAKE_BUILD_TYPE=Debug \
 -DCMAKE_INSTALL_PREFIX=/usr/local \
 -DWEECHAT_HOME=~/weechat-options \
 -DCA_FILE=/etc/ssl/certs/ca-certificates.crt \
 -DENABLE_ALIAS=ON \
 -DENABLE_BUFLIST=ON \
 -DENABLE_CHARSET=ON \
 -DENABLE_MAN=ON \
 -DENABLE_DOC=OFF \
 -DENABLE_ENCHANT=OFF \
 -DENABLE_EXEC=ON \
 -DENABLE_FIFO=ON \
 -DENABLE_FSET=ON \
 -DENABLE_GNUTLS=ON \
 -DENABLE_GUILE=OFF \
 -DENABLE_IRC=ON \
 -DENABLE_JAVASCRIPT=OFF \
 -DENABLE_LARGEFILE=ON \
 -DENABLE_LOGGER=ON \
 -DENABLE_LUA=OFF \
 -DENABLE_NCURSES=ON \
 -DENABLE_NLS=ON \
 -DENABLE_PERL=ON \
 -DENABLE_PHP=OFF \
 -DENABLE_PYTHON=ON \
 -DENABLE_PYTHON2=ON \
 -DENABLE_RELAY=ON \
 -DENABLE_RUBY=OFF \
 -DENABLE_SCRIPT=ON \
 -DENABLE_SCRIPTS=ON \
 -DENABLE_TCL=OFF \
 -DENABLE_TRIGGER=ON \
 -DENABLE_XFER=ON \
 -DENABLE_TESTS=OFF \
 -DENABLE_CODE_COVERAGE=OFF

make
```

## Installation
```
sudo make install
```

## Quellen

* https://weechat.org/files/doc/stable/weechat_user.de.html#compile_with_cmake
