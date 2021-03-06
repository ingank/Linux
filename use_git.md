# Kleines Git HowTo

## Grundeinstellungen
```
git config --global user.email "foo@bar.bazz"
git config --global user.name "foo"
```
## Die wichtigsten Befehle
```
# entferntes Repository lokal klonen
git clone foo
```
**Achtung:**  
Git-Befehle, die sich auf ein lokales Repository beziehen, werden im dazugehörigen Repo-Hauptverzeichnis ausgeführt. Dazu:
```
# Das obige Repository lokal aufsuchen
cd foo
```
Danach kann mit dem geklonten Repository gearbeitet werden:
```
# aktuellen Status des lokalen Repos ermitteln
git status

# Änderungen zusammentragen (to stage)
git add foo
git add .

# Zusammengetragene Änderungen committen
git commit

# Lokale Commits auf das entfernte Repo übertragen
git push

# Lokales Repo auf den Stand des entfernten Repos bringen
git fetch
git pull
```

## Spezialfälle

Sollen Änderungen an einer bestimmten Datei von git nicht registriert werden, so kann diese temporär aus dem INDEX entfernt werden:
```
git update-index --assume-unchanged foo
```
Die Datei kann nach Abschluß der gewünschten Arbeit wieder in den INDEX aufgenommen werden:
```
git update-index --no-assume-unchanged foo
```

## Quellen

* https://www.ralfebert.de/git/