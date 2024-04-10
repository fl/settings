##################
Linux Tools & Tips
##################

*************************************
In the beginning was the Command Line
*************************************

Das Command Line Interface (CLI), das auf Linux am meisten genutzt wird ist die Shell. In einem (virtuellen) Terminal ohne graphische Benutzeroberflaeche wird nach der Benutzeranmeldung die voreingestellte "login shell" ``bash`` gestartet. PCs mit Debian GNU/Linux haben in der Standardinstallation 6 Terminals konfiguriert, zwischen denen man mit ``Alt-F1`` bis ``Alt-F6`` umschalten kann. Wenn sie installiert ist, wird die graphische Benutzeroberflaeche auf Terminal 7 gestartet. Einmal in der graphischen Benutzeroberflaeche angekommen haben die Tastenkombinationen ``Alt-F1`` bis ``Alt-F6`` eine andere Bedeutung, die von der graphischen Benutzeroberflaeche abhaengt. Um wieder zurueck zu den Terminals zu kommen, verwendet man jetzt ``Ctrl-Alt-F1`` bis ``Ctrl-Alt-F6``.

In einer graphischen Benutzeroberflaeche (wie z.B. KDE) startet man virtuelles Terminal, das in seinem Fenster die Kommandozeile anzeigt.

In der Shell-Session ruft Programme auf, oder auch eingebaute Shell-Funktionen. Diese Programme koennen Text-Aufgabe erzeugen, die Ergebnisse oder Fehlermeldungen anzeigt. Mit dem Pipe-Zeichen ``|`` kann man die Ausgabe eines Programms in die Eingabe eines anderen Programms umleiten. Mit dem Umleitungszeichen ``>`` leitet man die Ausgabe in eine Datei, mit ``<`` liest man aus einer Datei (und uebergibt die gelesenen Zeilen dem gerufenen Porgramm).

Man kann Programme auch im Hintergrund ausfuehren, indem man den Aufruf mit dem Suffix ``&`` ergaenzt, und kann direkt nach dem Start eines solchen "Jobs" weiterarbeiten, waehrend im Hintergrund der Job die aufgerufene Kommandozeile ausfuehrt.

So schoen Shells sind, haben sie doch zwei wesentliche Probleme:

#. eine Shell kennt nur ein Fenster (bzw. eine Session)
#. wenn die Verbindung weg ist, ist meistens auch die Shell weg, zusammen mit dem was vielleicht gerade gelaufen ist

Dieses Problem gibt es schon ziemlich lange, und so gibt es auch die Loesung dafuer schon recht lange: den "Terminal Multiplexer", einen Window Manager fuer die Kommandozeile. Die beiden am haeufigsten verwendeten Porgranmme dafuer sind

* screen
* tmux

Beide koennen in einer Shell-Session mehr als eine Shell starten (in virtuellen Fenstern), und beide trennen die Session (Server-Seite) von der connection (client-Seite). Das bedeutet, dass eine getrennte Verbindung (Hund reisst das WLAN-Kabel raus und kappt die VPN-Verbindung) nur die Verbindung vom client zum server trennt, waehrend die session auf dem Server weiterlaeuft, vergleichbar mit einer Windows-Session, an der man sich mit Dameware oder VNC aufschaltet - wenn die Verbindung abbricht, laeuft die Windows-Session weiter, bis man sich wieder verbindet.

Wir betrachten zuerst screen.

*******************************
Screen, der console multiplexer
*******************************

Wenn screen noch nicht installiert ist, mit ``apt`` installieren::

    apt install screen

Mit dem Aufruf von ``screen`` (ohne Optionen) startet

* das screen Backend
* eine neue Shell session unter der Kontrolle des Backends
* ein screen Frontend

als user ``swadm`` gestartet schaut das so aus::

    fl@cornus:~$ pstree -t -a -p swadm
    bash,9916
      └─screen,9961
          └─screen,9962
              └─bash,9963

In der laufenden Shell (PID 9916) ruft der Benutzer swadm ``screen`` auf. Als erstes startet das screen backend (PID 9961), dann das screen frontend (PID 9962), dann eine neue login shell. Als Benutzer sieht man erstmal keinen Unterschied zwischen einer "normalen" Shell und einer Shell unter der Kontrolle von screen::

    root@cornus:~# su - swadm
    swadm@cornus:~$ screen
    swadm@cornus:~$ echo $$
    9963
    swadm@cornus:~$ exit
    [screen is terminating]
    swadm@cornus:~$ echo $$
    9916
    swadm@cornus:~$
