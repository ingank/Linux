# Schneller Screencast mit ffmpeg

Soll unter Linux vom derzeitigen Geschehen auf dem Bildschirm ein Video aufgenommen werden,
um es beispielsweise später ungeschnitten im Internet bereitzustellen,
bietet sich das meistens vorinstallierte *ffmpeg* an:

```
ffmpeg -video_size 1920x1080 \
  -framerate 30 \
  -f x11grab \
  -i :0.0 \
  output.mp4
```

Der obige Befehl erstellt die mp4-Video-Datei *output.mp4* mit den Maßen 1920x1080 Pixel
und bezieht sich auf die Koordinate links, oben (0.0).
Die Maße und die Bildwiederholrate kann an die eigenen Bedürfnisse angepasst werden.

Mit der Taste Q kann die Aufzeichnung gestoppt werden.

Heutiger Quasi-Standard für HD-Videos im Internet ist 1920x1080 Pixel in Breite und Länge
bei 30 bzw. 60 Hz Bildwiederholrate.
UHD-Videos werden in der Auflösung 3840x2160 Pixel angeboten.

## Spezialfälle

Über die VAAPI-API kann auch die GPU eines aktuellen Intel-Prozessors zum Encodieren des Videostreams genutzt werden:

```
sudo apt install i965-va-driver   # noch testen!

ffmpeg -f x11grab \
  -video_size 1920x1080 \
  -framerate 60 \
  -i :0.0 \
  -vaapi_device :0 \
  -vf 'format=nv12,hwupload' \
  -map 0:0 \
  -threads 8 \
  -aspect 16:9 -y \
  -g 30 \
  -f mp4 \
  -bf 0 \
  -qp 19 \
  -quality 2 \
  -vcodec h264_vaapi \
  test-vaapi.mp4
```
Erwähnenswert ist in diesem Zusammenhang die Option *-g 30*.
Sie ist für das Setzen der KeyFrames zuständig.
Im obigen Beispiel wird bei einer Framerate vom 60/s alle 1/2 Sekunde ein KeyFrame eingefügt.
Videos können ohne hohen Rechenaufwand an Keyframes geschnitten werden - im Gegensatz zu Schnitten dazwischen.

## Quellen

* https://ffmpeg.org/documentation.html
* https://ffmpeg.org/ffmpeg.html
