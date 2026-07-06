#############
Der ELK-Stack
#############

**WORK IN PROGRESS**

Der ELK-Stack wird so genannt, weil er anfangs bestand aus

* **E** lasticsearch
* **L** ogstash
* **K** ibana

inzwischen sind auch andere Komponenten dazugekommen:

* Beats
* APM (jetzt Observability genannt)
* Elastic Agent
* Fleet
* Elasticsearch ingest pipelines
* Elasticsearch clients
* Elasticsearch Hadoop

Auch wenn man jetzt von ELKAOEAFICH sprechen muesste, macht das niemand, denn wenn man aber mal ein schoenes `TLA`_ gefunden hat, gibt man es nur ungern auf, deswegen heisst die ganze Veranstaltung immer noch ELK-Stack.

*********************************
RTFM - das Elastic Doku-Labyrinth
*********************************

Die vorhandene `Elastic-Dokumentation`_ ist fein veraestelt, so sehr dass man sich auf den ersten Versuch schwertut den richtigen Einsteig zu finden. Sie ist aber sehr gut organisiert, und hat sogar eine `Doku zur Doku`_, die man lesen sollte (und bookmarken).

Fuer unsere Installation lesen wir den `Elastic Installation and Upgrade Guide`_, und achten darauf, dass wir nur on-premise Komponenten verwenden wollen, auf Debian 12. Aus dem `Elastic Stack`_ waehlen wir folgende Komponenten aus:

#. Elasticsearch
#. Kibana
#. Beats
#. Elastic Agent

Die Reihenfolge der Installation leiten wir aus dem Kapitel `Installation Order`_ ab. Dort sind auch die Installation guides nett verlinkt:

#. `Elasticsearch installation guide`_
#. `Kibana installation guide`_
#. `Beats installation guide`_
#. `Elastic Agent installation guide`_

*************
Elasticsearch
*************

Wir beginnen mit der Installation von Elasticsearch. Dazu verwenden wir eine Debian 12 (Bookworm) VM (Standard-Installation, in der Paket-Auswahl *tasksel* nur "SSH Server" ausgewaehlt). Aus Bequemlichkeit installieren wir zuerst **screen**, damit wir damit die Shell-Session in der wir installieren nicht verlieren wenn die connection abbricht.

wir sind auf Debian 11::

    root@stardust:~# cat /etc/debian_version
    11.6

also verwenden wir das deb-Paket: https://www.elastic.co/guide/en/elasticsearch/reference/8.13/deb.html

package signing key installieren
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Elastic signiert seine APT-Pakete mit einem eigenen key, den wir fuer das Elastic-Repository als vertrauenswuerdig konfigurieren. Dazu laden wir den key zuerst von der Elastic-Seite::

    root@stardust:~# wget https://artifacts.elastic.co/GPG-KEY-elasticsearch

jetzt haben wir den key lokal, aber "ascii armored", im PEM-Format::

    fl@sequoia:~$ cat GPG-KEY-elasticsearch
    -----BEGIN PGP PUBLIC KEY BLOCK-----
    mQENBFI3HsoBCADXDtbNJnxbPqB1vDNtCsqhe49vFYsZN9IOZsZXgp7aHjh6CJBD
    A+bGFOwyhbd7at35jQjWAw1O3cfYsKAmFy+Ar3LHCMkV3oZspJACTIgCrwnkic/9
    CUliQe324qvObU2QRtP4Fl0zWcfb/S8UYzWXWIFuJqMvE9MaRY1bwUBvzoqavLGZ
    j3SF1SPO+TB5QrHkrQHBsmX+Jda6d4Ylt8/t6CvMwgQNlrlzIO9WT+YN6zS+sqHd
    1YK/aY5qhoLNhp9G/HxhcSVCkLq8SStj1ZZ1S9juBPoXV1ZWNbxFNGwOh/NYGldD
    2kmBf3YgCqeLzHahsAEpvAm8TBa7Q9W21C8vABEBAAG0RUVsYXN0aWNzZWFyY2gg
    KEVsYXN0aWNzZWFyY2ggU2lnbmluZyBLZXkpIDxkZXZfb3BzQGVsYXN0aWNzZWFy
    Y2gub3JnPokBTgQTAQgAOAIbAwIXgBYhBEYJWsyFSFgsGiaZqdJ9ZmzYjkK0BQJk
    9vrZBQsJCAcDBRUKCQgLBRYCAwEAAh4FAAoJENJ9ZmzYjkK00hoH+wYXZKgVb3Wv
    4AA/+T1IAf7edwgajr58bEyqds6/4v6uZBneUaqahUqMXgLFRX5dBSrAS7bvE/jx
    +BBQx+rpFGxSwvFegRevE1zAGVtpgkFQX0RpRcKSmksucSBxikR/dPn9XdJSEVa8
    vPcs11V+2E5tq3LEP14zJL4MkJKQF0VJl5UUmKLS7U2F/IB5aXry9UWdMTnwNntX
    kl2iDaViYF4MC6xTS24uLwND2St0Jvjt+xGEwbdBVvp+UZ/kG6IGkYM5eWGPuok/
    DHvjUdwTfyO9b5xGbqn5FJ3UFOwB/nOSFXHM8rsHRT/67gHcIl8YFqSQXpIkk9D3
    dCY+KieW0ue5AQ0EUjceygEIAOSVJc3DFuf3LsmUfGpUmnCqoUm76Eqqm8xynFEG
    ZpczTChkwARRtckcfa/sGv376j+jk0c0Q71Uv3MnMLPGF+w3bpu8fLiPeW/cntf1
    8uZ6DxJvHA/oaZZ6VPjwUGSeVydiPtZfTYsceO8Dxl3gpS6nHZ9Gsnfr/kcH9/11
    Ca73HBtmGVIkOI1mZKMbANO8cewY/i7fPxShu7B0Rb3jxVNGUuiRcfRiao0gWx0U
    ZGpvuHplt7loFX2cbsHFAp9WsjYEbSohb/Y0K4NkyFhL82MfbcsEwsXPhRTFgJWw
    s4vpuFg/kFFlnw0NNPVP1jNJLNCsMBMEpP1A7k6MRpylNnUAEQEAAYkBNgQYAQgA
    IAIbDBYhBEYJWsyFSFgsGiaZqdJ9ZmzYjkK0BQJk9vsHAAoJENJ9ZmzYjkK0hWsH
    /ArKtn12HM3+41zYo9qO4rTri7+IYTjSB/JDTOusZgZLd/HCp1xQo4SI2Eur3Rtx
    USMWK1LEeBzsjwDT9yVceYekrBEqUVyRMSVYj+UeZK2s4LbXm9b4jxXVtaivmkMA
    jtznndrD7kmm8ak+UsZplf6p6uZS9TZ9hjwoMmw5oMaS6TZkLT4KYGWeyzHJSUBX
    YikY6vssDQu4SJ07m1f4Hz81J39QOcHln5I5HTK8Rh/VUFcxNnGg9360g55wWpiF
    eUTeMyoXpOtffiUhiOtbRYsmSYC0D4Fd5yJnO3n1pwnVVVsM7RAC22rc5j/Dw8dR
    GIHikRcYWeXTYW7veewK5Ss=
    =ftS0
    -----END PGP PUBLIC KEY BLOCK-----

damit APT ihn verwenden kann muessen wir ihn auspacken (=in das GPG-Keyring Format konvertieren)::

    fl@sequoia:~ gpg --dearmor < GPG-KEY-elasticsearch > elastic.co-APT-signingkey.gpg

Mit gpg koennen wir den Inhalt kontrollieren::

    fl@sequoia:~$ gpg --show-keys elastic.co-APT-signingkey.gpg
    pub   rsa2048 2013-09-16 [SC]
          46095ACC8548582C1A2699A9D27D666CD88E42B4
    uid                      Elasticsearch (Elasticsearch Signing Key) <dev_ops@elasticsearch.org>
    sub   rsa2048 2013-09-16 [E]

Nun konfigurieren wir diesen key als vertrauenswuerdig, aber nur fuer die Repositories, die Elastic verwaltet. Das steuern wir durch ``[signed-by=<pfad-zum-key>]``  fuer eine deb-Zeile. Wir wollen ihn ganz explizit *nicht* nach ``/etc/apt/trusted.gpg.d/`` kopieren, weil dann alle Pakete aus allen Quellen mit dem Elastic-Key signiert sein duerften. Dazu legen wir den keyring nach ``/usr/local/share/keyrings/`` und verwenden diesen Pfad im sources file::

    root@sequoia:~# cp ~fl/elastic.co-APT-signingkey.gpg /usr/local/share/keyrings/

    root@sequoia:~# echo "deb [signed-by=/usr/local/share/keyrings/elastic.co-APT-signingkey.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" > /etc/apt/sources.list.d/elastic-8.x.list

package-Information auffrischen::

    root@stardust:~# apt update

mal nach Elastic suchen::


weil Elastic aus irgendwelchen Gruenden directory-index abgeschaltet hat, muessen wir erfinderisch werden, umd das repo zu spiegeln, damit wir es ohne proxy/internetz installieren koennen. Elastic gibt als repo URL selbst an: ``https://artifacts.elastic.co/packages/8.x/apt``. Nachdem wir die package-Struktur eines Debian repos kennen, bedeutet dies, dass wir ein ``Packages.gz`` fuer unsere Plattform finden unter ``<REPO-URL>/dists/stable/main/binary-amd64/Packages.gz``. Und genau damit probieren wir es:

``wget ``https://artifacts.elastic.co/packages/8.x/apt/dists/stable/main/binary-amd64/Packages.gz``

der mirror stellt laut ``Packages.gz`` diese files bereit::

    fl@sequoia:~/Downloads$ zcat Packages.gz | grep '^Filename: '
    [...]
    Filename: pool/main/e/elasticsearch/elasticsearch-8.13.1-amd64.deb
    Filename: pool/main/e/elasticsearch/elasticsearch-8.13.0-amd64.deb
    Filename: pool/main/e/elasticsearch/elasticsearch-8.12.2-amd64.deb
    Filename: pool/main/e/elasticsearch/elasticsearch-8.12.1-amd64.deb
    [...]

der Pfad ist relativ zur REPO-URL, wir koennen uns also ein mirror-skript bauen:

PREFIX: ``https://artifacts.elastic.co/packages/8.x/apt/``
FILEPATH (Beispiel) ``pool/main/e/elasticsearch/elasticsearch-8.12.1-amd64.deb``

ein download-link waere also:

``https://artifacts.elastic.co/packages/8.x/apt/pool/main/e/elasticsearch/elasticsearch-8.12.1-amd64.deb``

ausprobieren: geht! hier gehts morgen weiter.

TODO --> EYECATCHER EDITMARK <--

und genau das werden wir jetzt installieren::

    root@stardust:~# apt install elasticsearch
    Reading package lists... Done
    Building dependency tree... Done
    Reading state information... Done
    The following package was automatically installed and is no longer required:
      linux-headers-5.10.0-18-common
    Use 'apt autoremove' to remove it.
    The following NEW packages will be installed:
      elasticsearch
    0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
    Need to get 596 MB of archives.
    After this operation, 1234 MB of additional disk space will be used.
    Get:1 https://artifacts.elastic.co/packages/8.x/apt stable/main amd64 elasticsearch amd64 8.7.0 [596 MB]
    47% [1 elasticsearch 350 MB/596 MB 59%]                                                  29.5 MB/s 8s

wenn die Instalation durch ist sieht der komplette output so aus::

    root@stardust:~# apt install elasticsearch
    Reading package lists... Done
    Building dependency tree... Done
    Reading state information... Done
    The following package was automatically installed and is no longer required:
      linux-headers-5.10.0-18-common
    Use 'apt autoremove' to remove it.
    The following NEW packages will be installed:
      elasticsearch
    0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
    Need to get 596 MB of archives.
    After this operation, 1234 MB of additional disk space will be used.
    Get:1 https://artifacts.elastic.co/packages/8.x/apt stable/main amd64 elasticsearch amd64 8.7.0 [596 MB]
    Fetched 596 MB in 23s (25.7 MB/s)
    Selecting previously unselected package elasticsearch.
    (Reading database ... 86816 files and directories currently installed.)
    Preparing to unpack .../elasticsearch_8.7.0_amd64.deb ...
    Creating elasticsearch group... OK
    Creating elasticsearch user... OK
    Unpacking elasticsearch (8.7.0) ...
    Setting up elasticsearch (8.7.0) ...
    --------------------------- Security autoconfiguration information ------------------------------

    Authentication and authorization are enabled.
    TLS for the transport and HTTP layers is enabled and configured.

    The generated password for the elastic built-in superuser is : cqW5=JtY7E*qgxFOB3Hr

    If this node should join an existing cluster, you can reconfigure this with
    '/usr/share/elasticsearch/bin/elasticsearch-reconfigure-node --enrollment-token <token-here>'
    after creating an enrollment token on your existing cluster.

    You can complete the following actions at any time:

    Reset the password of the elastic built-in superuser with
    '/usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic'.

    Generate an enrollment token for Kibana instances with
     '/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana'.

    Generate an enrollment token for Elasticsearch nodes with
    '/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s node'.

    -------------------------------------------------------------------------------------------------
    ### NOT starting on installation, please execute the following statements to configure elasticsearch service to start automatically using systemd
     sudo systemctl daemon-reload
     sudo systemctl enable elasticsearch.service
    ### You can start elasticsearch service by executing
     sudo systemctl start elasticsearch.service
    root@stardust:~#

und nachdem das so schoen erklaert wird wie man startet machen wir genau das::

    root@stardust:~# systemctl daemon-reload
    root@stardust:~# systemctl enable elasticsearch.service
    Created symlink /etc/systemd/system/multi-user.target.wants/elasticsearch.service → /lib/systemd/system/elasticsearch.service.
    root@stardust:~# systemctl start elasticsearch.service

jetzt sehen wir Java-Prozesse die dem user elasticsearch gehoeren::

    root@stardust:~# ps -u elasticsearch
        PID TTY          TIME CMD
      23066 ?        00:00:03 java
      23127 ?        00:00:41 java
      23156 ?        00:00:00 controller

nun schauen wir ob der webservice laeuft, zuerst mit nmap (ob der port offen ist), dann mit curl auf den Elastic API endpoint. Das Passwort fuer den user elastic ist das was vorhin als "Master Password" angezeigt wurde.

nmap::

    root@stardust:~# nmap localhost
    Starting Nmap 7.80 ( https://nmap.org ) at 2023-04-19 12:46 CEST
    Nmap scan report for localhost (127.0.0.1)
    Host is up (0.0000020s latency).
    Other addresses for localhost (not scanned): ::1
    rDNS record for 127.0.0.1: localhost.localdomain
    Not shown: 997 closed ports
    PORT     STATE SERVICE
    22/tcp   open  ssh
    3128/tcp open  squid-http
    9200/tcp open  wap-wsp

    Nmap done: 1 IP address (1 host up) scanned in 0.09 seconds

und curl::

    root@stardust:~# curl --cacert /etc/elasticsearch/certs/http_ca.crt -u elastic https://localhost:9200
    Enter host password for user 'elastic':
    {
      "name" : "stardust",
      "cluster_name" : "elasticsearch",
      "cluster_uuid" : "cnn3RmnaQJGe-A-V7xJKXg",
      "version" : {
        "number" : "8.7.0",
        "build_flavor" : "default",
        "build_type" : "deb",
        "build_hash" : "09520b59b6bc1057340b55750186466ea715e30e",
        "build_date" : "2023-03-27T16:31:09.816451435Z",
        "build_snapshot" : false,
        "lucene_version" : "9.5.0",
        "minimum_wire_compatibility_version" : "7.17.0",
        "minimum_index_compatibility_version" : "7.0.0"
      },
      "tagline" : "You Know, for Search"
    }

und auch remote sehen wir dass der port 9200/tcp jetzt offen ist::

    root@devkibana:~# nmap stardust
    Starting Nmap 7.80 ( https://nmap.org ) at 2023-04-19 12:47 CEST
    Nmap scan report for stardust (10.143.1.127)
    Host is up (0.00024s latency).
    rDNS record for 10.143.1.127: stardust.pc.bgu-murnau.de
    Not shown: 998 closed ports
    PORT     STATE SERVICE
    22/tcp   open  ssh
    9200/tcp open  wap-wsp

    Nmap done: 1 IP address (1 host up) scanned in 0.16 seconds

Anmerkung: den port 3128/tcp sehen wir hier nicht, weil der lokale proxy so konfiguriert ist dass er nur auf localhost:3128 bindet und nicht auf *:3128*

Wenn wir den API-Aufruf auch von extern machen wollen muessen wir das Elatic-Zertifikat auch dort dem curl zur Verfuegung stellen::

    isabell@stardust:~$ scp stardust:/etc/elasticsearch/certs/http_ca.crt stardust_http_ca.crt

    isabell@stardust:~$ curl --cacert stardust_http_ca.crt -u elastic https://stardust:9200
    Enter host password for user 'elastic':
    {
      "name" : "stardust",
      "cluster_name" : "elasticsearch",
      "cluster_uuid" : "cnn3RmnaQJGe-A-V7xJKXg",
      "version" : {
        "number" : "8.7.0",
        "build_flavor" : "default",
        "build_type" : "deb",
        "build_hash" : "09520b59b6bc1057340b55750186466ea715e30e",
        "build_date" : "2023-03-27T16:31:09.816451435Z",
        "build_snapshot" : false,
        "lucene_version" : "9.5.0",
        "minimum_wire_compatibility_version" : "7.17.0",
        "minimum_index_compatibility_version" : "7.0.0"
      },
      "tagline" : "You Know, for Search"
    }

diese Install-Schritte wiederholen wir jetzt fuer die Knoten -04 und -05, mit der kleinen Abweichung dass wir beide installieren aber nicht starten, dann einen enrollment key fuer den cluster auf -03 erzeugen, und m,it diesem enrollment key die beiden neuen umconfigurieren als cluster member. Wenn der reconfig abgeschlossen ist duerfen auch die beiden starten

erst aber: wir versorgen den neuen clusternode mit einem eigenen Zertifikat

Elastic docs dazu: https://www.elastic.co/guide/en/elasticsearch/reference/current/update-node-certs-same.html

zweiter Knoten
--------------

- proxy + certificates konfiguriert
- elastic key vertraut
- apt update & apt install elasticsearch

 ::

    Reading package lists... Done
    Building dependency tree... Done
    Reading state information... Done
    The following package was automatically installed and is no longer required:
      linux-headers-5.10.0-18-common
    Use 'apt autoremove' to remove it.
    The following NEW packages will be installed:
      elasticsearch
    0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
    Need to get 596 MB of archives.
    After this operation, 1234 MB of additional disk space will be used.
    Get:1 https://artifacts.elastic.co/packages/8.x/apt stable/main amd64 elasticsearch amd64 8.7.0 [596 MB]
    11% [1 elasticsearch 80.0 MB/596 MB 13%]                                           1157 kB/s 7min 25s^Fetched 596 MB in 8min 32s (1165 kB/s)
    Selecting previously unselected package elasticsearch.
    (Reading database ... 88291 files and directories currently installed.)
    Preparing to unpack .../elasticsearch_8.7.0_amd64.deb ...
    Creating elasticsearch group... OK
    Creating elasticsearch user... OK
    Unpacking elasticsearch (8.7.0) ...
    Setting up elasticsearch (8.7.0) ...
    --------------------------- Security autoconfiguration information ------------------------------

    Authentication and authorization are enabled.
    TLS for the transport and HTTP layers is enabled and configured.

    The generated password for the elastic built-in superuser is : DVs5L8iHyc9Ny=qM=Pg_

    If this node should join an existing cluster, you can reconfigure this with
    '/usr/share/elasticsearch/bin/elasticsearch-reconfigure-node --enrollment-token <token-here>'
    after creating an enrollment token on your existing cluster.

    You can complete the following actions at any time:

    Reset the password of the elastic built-in superuser with
    '/usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic'.

    Generate an enrollment token for Kibana instances with
     '/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana'.

    Generate an enrollment token for Elasticsearch nodes with
    '/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s node'.

    -------------------------------------------------------------------------------------------------
    ### NOT starting on installation, please execute the following statements to configure elasticsearch service to start automatically using systemd
     sudo systemctl daemon-reload
     sudo systemctl enable elasticsearch.service
    ### You can start elasticsearch service by executing
     sudo systemctl start elasticsearch.service

damit der als neues cluster meber online kommen kann:

- node 1
    - enrollment token erzeugen
- node 2
    - mur certificate installieren fuer elastic
    - clustername setzen
    - reconfig mit dem enrollment token
    - starten

alles Kaese - das Skript funktioniert nur wenn auf dem host, auf dem das enrollment token erzeugt werden soll ein CA certificate liegt das beliebige certificates ausstellen kann fuer neue nodes. Eigentlich logisch :-)

das geht bei uns natuerlich nicht - sowohl zur Issue-CA als auch zur Root-CA haben wir keinen private key. Deswegen scheiter das enrollment skript::

    root@stardust:/etc/elasticsearch/certs# /usr/share/elasticsearch/bin/elasticsearch-create-enro
    llment-token -s node
    Unable to create enrollment token for scope [node]

    ERROR: Unable to create an enrollment token. Elasticsearch node HTTP layer SSL configuration Keystore doesn't contain any PrivateKey entries where the associated certificate is a CA certificate




.. _TLA: https://en.wikipedia.org/wiki/Three-letter_acronym
.. _Elastic-Dokumentation:
.. _Doku zur Doku: https://www.elastic.co/guide/en/starting-with-the-elasticsearch-platform-and-its-solutions/current/introducing-elastic-documentation.html
.. _Elastic Stack: https://www.elastic.co/guide/en/starting-with-the-elasticsearch-platform-and-its-solutions/current/stack-components.html
.. _Elastic Installation and Upgrade Guide: https://www.elastic.co/guide/en/elastic-stack/current/index.html
.. _Installation Order: https://www.elastic.co/guide/en/elastic-stack/current/installing-elastic-stack.html#install-order-elastic-stack
.. _Elasticsearch installation guide: https://www.elastic.co/guide/en/elasticsearch/reference/8.13/install-elasticsearch.html
.. _Kibana installation guide: https://www.elastic.co/guide/en/kibana/8.13/install.html
.. _Beats installation guide: https://www.elastic.co/guide/en/beats/libbeat/8.13/getting-started.html
.. _Elastic Agent installation guide: https://www.elastic.co/guide/en/fleet/8.13/elastic-agent-installation.html
