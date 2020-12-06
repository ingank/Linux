# Passwörter erstellen und benutzen

Auch wenn dem Benutzer dies nicht immer bewusst ist - die Auswahl eines RICHTIGEN Passwortes ist komplex. Es muss im Idealfall:

* sicher
* für den Benutzer merkbar // erinnerbar
* einmalig
* auf den Zeichenvorrat des Eingabegeräts zugeschnitten

sein.

## Sicherheit

Die Sicherheit eines Passwortes ergibt sich aus den Parametern
* Länge
* Komplexität
* Erratbarkeit
* statistische Nutzungshäufigkeit von Passwortteilen

## Merkbarkeit

Ein Passwort ist dann merkbar,
wenn der Nutzer es ohne Hilfsmittel aus dem Gedächnis reproduzieren kann.
Zwangsläufig wird ein Passwort immer ein Kompromiss zwischen Sicherheit und Merkbarkeit darstellen.
Passwortmanager verschieben diesen Kompromiss in Richtung Sicherheit.

Wichtig ist, in diesem Zusammenhang zu erwähnen, dass alle im Passwortmananger gespeicherten Passwörter maximal so sicher sind, wie das Passwort zum Passwortmanager selbst.

## Einmaligkeit

Jeder Nutzerzugang sollte mit einem eigenen Passwort gesichert werden.

## Zeichenvorrat des Eingabegerätes

Passwörter werden im Normalfall über eine an das Zugangsgerät angeschlossene Tastatur eingegeben.
Was im Herkunftsland des Nutzers eine *deutsche Tastatur* ist,
kann anderswo beispielsweise eine *amerikanische Tastatur* sein.

Wenn die Software ein Eingabegerät nicht auf ein bestimmtes Layout
einstellt, dann ist zu 99,9% das Layout *English (US)* voreingestellt.
Deshalb sollte das Tastaturlayout
der Tastatur *English (US)* als Ausdruck
oder besser noch eine eigens dafür vorhandene Hardware,
in keinem Notfallset für Administratoren fehlen.

Wenn also ein *deutschsprachiger Nutzer* die Entscheidung bewusst getroffen hat, ein Passwort aus Zeichen der US-Tastatur zu bilden,
dann kann er für beide Tastaturlayouts
Zeichen aus dem folgenden Pool nutzen:

* Alle kleinen und großen Buchstaben ohne *z,y,Z,Y*
* Alle Ziffern
* Die Sonderzeichen: *! $ % , . < > |*

**Zusammenfassung zum Zeichenvorrat:** Wenn anzunehmenden ist,
dass nicht zu JEDEM Authentifizierungsvorgang die gleiche
Eingabehardware bzw. das gleiche logische Layout vorliegt,
sollte ein Passwort aus dem Zeichenvorrat der Tastatur *English (US)* gebildet werden.
