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
* APM (jetzt um Observability genannt)
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

Wir beginnen mit der Installation von Elasticsearch. Dazu verwenden wir eine Debian 12 (Bookworm) VM (Standard-Installation, in der Paket-Auswahl *tasksel* nur "SSH Server" ausgewaehlt). Aus Bequemlichkeit installieren wir zuerst **screen**::

    apt install screen

weil wir damit die Shell-Session in der wir installieren nicht verlieren wenn die connection abbricht.


**TODO - das ist vom letzten install auf bullseye mit Elasticsearch 8.7 uebernommen, update me auf 8.13**

wir sind auf Debian 11::

    root@stardust:~# cat /etc/debian_version
    11.6

also verwenden wir das deb-Paket: https://www.elastic.co/guide/en/elasticsearch/reference/8.7/deb.html

package signing key installieren
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

beim download macht der lokale wget Zicken, obwohl das environment richtig gesetzt ist::

    root@stardust:~# env | grep prox
    http_proxy=http://localhost:3128

    root@stardust:~# man wget
    root@stardust:~# systemctl status cntlm
    ● cntlm.service - LSB: Authenticating HTTP accelerator for NTLM secured proxies
         Loaded: loaded (/etc/init.d/cntlm; generated)
         Active: active (running) since Wed 2023-04-19 09:34:54 CEST; 1h 46min ago
           Docs: man:systemd-sysv-generator(8)
        Process: 1271 ExecStart=/etc/init.d/cntlm start (code=exited, status=0/SUCCESS)
          Tasks: 1 (limit: 19091)
         Memory: 1.0M
            CPU: 284ms
         CGroup: /system.slice/cntlm.service
                 └─1289 /usr/sbin/cntlm -U cntlm -P /var/run/cntlm/cntlm.pid

    Apr 19 09:34:54 stardust cntlm[1288]: New ACL rule: deny 0.0.0.0/0
    Apr 19 09:34:54 stardust cntlm[1288]: Workstation name used: stardust
    Apr 19 09:34:54 stardust cntlm[1271]: Starting CNTLM Authentication Proxy: cntlm.
    Apr 19 09:34:54 stardust cntlm[1288]: Using following NTLM hashes: NTLMv2(0) NT(1) LM(1)
    Apr 19 09:34:54 stardust systemd[1]: Started LSB: Authenticating HTTP accelerator for NTLM se>
    Apr 19 09:34:54 stardust cntlm[1289]: Daemon ready
    Apr 19 09:34:54 stardust cntlm[1289]: Changing uid:gid to 105:65534 - Success
    Apr 19 11:20:09 stardust cntlm[1289]: Using proxy proxyueberspace.de:8080
    Apr 19 11:20:09 stardust cntlm[1289]: 127.0.0.1 GET http://security.debian.org/debian-securit>
    Apr 19 11:20:10 stardust cntlm[1289]: 127.0.0.1 GET http://security.debian.org/debian-securit>

    root@stardust:~# wget https://artifacts.elastic.co/GPG-KEY-elasticsearch
    --2023-04-19 11:21:54--  https://artifacts.elastic.co/GPG-KEY-elasticsearch
    Resolving artifacts.elastic.co (artifacts.elastic.co)... 34.120.127.130, 2600:1901:0:1d7::
    Connecting to artifacts.elastic.co (artifacts.elastic.co)|34.120.127.130|:443... ^C

workaround: lokal den GPG key fuer das Elastic repository runterladen und auf den deve3 kopieren

jetzt haben wir den key lokal, aber "ascii armored"::

    root@stardust:~# cat GPG-KEY-elasticsearch
    -----BEGIN PGP PUBLIC KEY BLOCK-----
    Version: GnuPG v2.0.14 (GNU/Linux)

    mQENBFI3HsoBCADXDtbNJnxbPqB1vDNtCsqhe49vFYsZN9IOZsZXgp7aHjh6CJBD
    A+bGFOwyhbd7at35jQjWAw1O3cfYsKAmFy+Ar3LHCMkV3oZspJACTIgCrwnkic/9
    CUliQe324qvObU2QRtP4Fl0zWcfb/S8UYzWXWIFuJqMvE9MaRY1bwUBvzoqavLGZ
    j3SF1SPO+TB5QrHkrQHBsmX+Jda6d4Ylt8/t6CvMwgQNlrlzIO9WT+YN6zS+sqHd
    1YK/aY5qhoLNhp9G/HxhcSVCkLq8SStj1ZZ1S9juBPoXV1ZWNbxFNGwOh/NYGldD
    2kmBf3YgCqeLzHahsAEpvAm8TBa7Q9W21C8vABEBAAG0RUVsYXN0aWNzZWFyY2gg
    KEVsYXN0aWNzZWFyY2ggU2lnbmluZyBLZXkpIDxkZXZfb3BzQGVsYXN0aWNzZWFy
    Y2gub3JnPokBOAQTAQIAIgUCUjceygIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgEC
    F4AACgkQ0n1mbNiOQrRzjAgAlTUQ1mgo3nK6BGXbj4XAJvuZDG0HILiUt+pPnz75
    nsf0NWhqR4yGFlmpuctgCmTD+HzYtV9fp9qW/bwVuJCNtKXk3sdzYABY+Yl0Cez/
    7C2GuGCOlbn0luCNT9BxJnh4mC9h/cKI3y5jvZ7wavwe41teqG14V+EoFSn3NPKm
    TxcDTFrV7SmVPxCBcQze00cJhprKxkuZMPPVqpBS+JfDQtzUQD/LSFfhHj9eD+Xe
    8d7sw+XvxB2aN4gnTlRzjL1nTRp0h2/IOGkqYfIG9rWmSLNlxhB2t+c0RsjdGM4/
    eRlPWylFbVMc5pmDpItrkWSnzBfkmXL3vO2X3WvwmSFiQbkBDQRSNx7KAQgA5JUl
    zcMW5/cuyZR8alSacKqhSbvoSqqbzHKcUQZmlzNMKGTABFG1yRx9r+wa/fvqP6OT
    RzRDvVS/cycws8YX7Ddum7x8uI95b9ye1/Xy5noPEm8cD+hplnpU+PBQZJ5XJ2I+
    1l9Nixx47wPGXeClLqcdn0ayd+v+Rwf3/XUJrvccG2YZUiQ4jWZkoxsA07xx7Bj+
    Lt8/FKG7sHRFvePFU0ZS6JFx9GJqjSBbHRRkam+4emW3uWgVfZxuwcUCn1ayNgRt
    KiFv9jQrg2TIWEvzYx9tywTCxc+FFMWAlbCzi+m4WD+QUWWfDQ009U/WM0ks0Kww
    EwSk/UDuToxGnKU2dQARAQABiQEfBBgBAgAJBQJSNx7KAhsMAAoJENJ9ZmzYjkK0
    c3MIAIE9hAR20mqJWLcsxLtrRs6uNF1VrpB+4n/55QU7oxA1iVBO6IFu4qgsF12J
    TavnJ5MLaETlggXY+zDef9syTPXoQctpzcaNVDmedwo1SiL03uMoblOvWpMR/Y0j
    6rm7IgrMWUDXDPvoPGjMl2q1iTeyHkMZEyUJ8SKsaHh4jV9wp9KmC8C+9CwMukL7
    vM5w8cgvJoAwsp3Fn59AxWthN3XJYcnMfStkIuWgR7U2r+a210W6vnUxU4oN0PmM
    cursYPyeV0NX/KQeUeNMwGTFB6QHS/anRaGQewijkrYYoTNtfllxIu9XYmiBERQ/
    qPDlGRlOgVTd9xUfHFkzB52c70E=
    =92oX
    -----END PGP PUBLIC KEY BLOCK-----

damit APT ihn verwenden kann muessen wir ihn in das GPG-Keyring Format konvertieren::

    root@stardust:~# gpg --dearmor < GPG-KEY-elasticsearch > /usr/local/share/

Format kontrollieren::

    root@stardust:~# file /usr/share/keyrings/elasticsearch-keyring_2013-09-16.gpg
    /usr/share/keyrings/elasticsearch-keyring_2013-09-16.gpg: PGP/GPG key public ring (v4) created Mon Sep 16 17:07:54 2013 RSA (Encrypt or Sign) 2048 bits MPI=0xd70ed6cd267c5b3e...

schaut gut aus! Inhalt kontrollieren::

    root@stardust:~# gpg --show-keys < /usr/share/keyrings/elasticsearch-keyring_2013-09-16.gpg
    pub   rsa2048 2013-09-16 [SC]
          46095ACC8548582C1A2699A9D27D666CD88E42B4
    uid                      Elasticsearch (Elasticsearch Signing Key) <dev_ops@elasticsearch.org>
    sub   rsa2048 2013-09-16 [E]

jetzt das APT repo konfigurieren, und in der Kommandozeile den Pfad fuer den Elastic key anpassen::

    root@stardust:~# echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring_2013-09-16.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" > /etc/apt/sources.list.d/elastic-8.x.list



root@stardust:~# cat /etc/apt/sources.list.d/elastic-8.x.list
deb [signed-by=/usr/share/keyrings/elasticsearch-keyring_2013-09-16.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main

package-Information auffrischen::

    root@stardust:~# apt update
    Hit:1 http://security.debian.org/debian-security bullseye-security/updates InRelease
    Hit:2 http://ftp.de.debian.org/debian bullseye InRelease
    Err:3 https://artifacts.elastic.co/packages/8.x/apt stable InRelease
      Certificate verification failed: The certificate is NOT trusted. The certificate issuer is unknown.  Could not handshake: Error in the certificate verification. [IP: 127.0.0.1 3128]
    Get:4 http://ftp.de.debian.org/debian bullseye-updates InRelease [44.1 kB]
    Fetched 44.1 kB in 0s (104 kB/s)
    Reading package lists... Done
    Building dependency tree... Done
    Reading state information... Done
    All packages are up to date.
    W: Failed to fetch https://artifacts.elastic.co/packages/8.x/apt/dists/stable/InRelease  Certificate verification failed: The certificate is NOT trusted. The certificate issuer is unknown.  Could not handshake: Error in the certificate verification. [IP: 127.0.0.1 3128]
    W: Some index files failed to download. They have been ignored, or old ones used instead.

aber halt - haessliche Fehler beim Update, deswegen: Exkurs:

stardust laeuft noch ueber den proxy, bzw. genauer: erst ueber den lokalen cntlm Proxy und damnn ueber den
"echten" proxy.ubrspace.de:8080

alle TLS-connections nach draussen muessen also den "alten" Zertifikaten vom proxy vertrauen:

root@stardust:~# ls -1 /usr/share/ca-certificates/
/usr/share/ca-certificates/Proxy_Certificate.crt
/usr/share/ca-certificates/MyRootCA_Certificate.crt

damit die von Debian-Tools verwendet werden, muessen sie erstmal in dem diretory sein, dann in der config-Datei /etc/ca-certificates.conf und dann muss man noch einen reconfigure ausfuehren

root@stardust:~# ls -1 /usr/local/share/ca-certificates/ >> /etc/ca-certificates.conf

jetzt sind die Proxy-Zertifikate sichtbar in /etc/ssl/certs und werden auch in das "Cert bundle" eingepackt. Manche Applikationen unterstuetzen nur "cert bundles", d.h. alle Zertifikate in einem file, und nicht "cert directories", als EInzel-Zertifikate in einem directory

und jetzt funktionierts, automagically::

    root@stardust:~# apt update
    Hit:1 http://security.debian.org/debian-security bullseye-security/updates InRelease
    Hit:2 http://ftp.de.debian.org/debian bullseye InRelease
    Get:3 https://artifacts.elastic.co/packages/8.x/apt stable InRelease [10.4 kB]
    Hit:4 http://ftp.de.debian.org/debian bullseye-updates InRelease
    Get:5 https://artifacts.elastic.co/packages/8.x/apt stable/main amd64 Packages [48.4 kB]
    Fetched 58.8 kB in 0s (156 kB/s)
    Reading package lists... Done
    Building dependency tree... Done
    Reading state information... Done
    All packages are up to date.

mal nach Elastic suchen::

    root@stardust:~# apt search elastic
    Sorting... Done
    Full Text Search... Done
    apm-server/stable 8.7.0 amd64
      Elastic APM Server

    awscli/stable 1.19.1-1 all
      Universal Command Line Environment for AWS

    cba/stable 0.3.6-5 amd64
      Continuous Beam Analysis

    cp2k/stable 8.1-9 amd64
      Ab Initio Molecular Dynamics

    elastalert/stable 0.2.4-1 all
      easy and flexible alerting with Elasticsearch

    elastalert-doc/stable 0.2.4-1 all
      easy and flexible alerting with Elasticsearch (documentation)

    elastic-agent/stable 8.7.0 amd64
      Agent manages other beats based on configuration provided.

    elasticsearch/stable 8.7.0 amd64
      Distributed RESTful search engine built for the cloud

    elasticsearch-curator/stable 5.8.1-1 all
      command-line tool for managing Elasticsearch time-series indices

    fenicsx-performance-tests/stable 0.0~git20210119.80e82ac-1 amd64
      Performance test codes for FEniCS/DOLFIN-X (binaries)

    fenicsx-performance-tests-source/stable 0.0~git20210119.80e82ac-1 all
      Performance test codes for FEniCS/DOLFIN-X (source)

    filebeat/stable 8.7.0 amd64
      Filebeat sends log files to Logstash or directly to Elasticsearch.

    golang-github-denverdino-aliyungo-dev/stable 0.0~git20180921.13fa8aa-2 all
      Go SDK for Aliyun (Alibaba Cloud)

    golang-github-jedisct1-dlog-dev/stable 0.7-1 all
      Super simple logger for Go

    golang-github-timberio-go-datemath-dev/stable 0.1.0+git20200323.74ddef6-2 all
      Go library for parsing Elasticsearch datemath expressions

    golang-gopkg-olivere-elastic.v2-dev/stable 2.0.12-2 all
      Elasticsearch client for Golang

    golang-gopkg-olivere-elastic.v3-dev/stable 3.0.41-1.1 all
      Elasticsearch client for Golang

    golang-gopkg-olivere-elastic.v5-dev/stable 5.0.83-1 all
      Elasticsearch client for Golang

    heartbeat-elastic/stable 8.7.0 amd64
      Ping remote services for availability and log results to Elasticsearch or send to Logstash.

    ibverbs-providers/stable 33.2-1 amd64
      User space provider drivers for libibverbs

    kibana/stable 8.7.0 amd64
      Explore and visualize your Elasticsearch data

    libcatmandu-perl/stable 1.2012-2 all
      metadata toolkit

    libcatmandu-store-elasticsearch-perl/stable 1.0202-1 all
      searchable store backed by Elasticsearch

    libnet-amazon-ec2-perl/stable 0.36-1 all
      Perl interface to the Amazon Elastic Compute Cloud (EC2)

    libopenhft-chronicle-bytes-java/stable 1.1.15-2 all
      OpenHFT byte buffer library

    librheolef-dev/stable 7.1-6 amd64
      efficient Finite Element environment - development files

    librheolef1/stable 7.1-6 amd64
      efficient Finite Element environment - shared library

    librust-tabwriter+ansi-formatting-dev/stable 1.2.1-1 amd64
      Elastic tabstops - feature "ansi_formatting"

    librust-tabwriter+lazy-static-dev/stable 1.2.1-1 amd64
      Elastic tabstops - feature "lazy_static"

    librust-tabwriter+regex-dev/stable 1.2.1-1 amd64
      Elastic tabstops - feature "regex"

    librust-tabwriter-dev/stable 1.2.1-1 amd64
      Elastic tabstops - Rust source code

    libsearch-elasticsearch-client-1-0-perl/stable 6.81-1 all
      Module to add client support for Elasticsearch 1.x

    libsearch-elasticsearch-client-2-0-perl/stable 6.81-1 all
      Thin client with full support for Elasticsearch 2.x APIs

    libsearch-elasticsearch-perl/stable 7.30-1 all
      Perl client for Elasticsearch

    libtrilinos-ml-dev/stable 12.18.1-2 amd64
      multigrid preconditioning - development files

    libtrilinos-ml12/stable 12.18.1-2 amd64
      multigrid preconditioning - runtime files

    nastran/stable 0.1.95-2 amd64
      NASA Structural Analysis System

    nwchem/stable 7.0.2-1 amd64
      High-performance computational chemistry software

    packetbeat/stable 8.7.0 amd64
      Packetbeat analyzes network traffic and sends the data to Elasticsearch.

    php-horde-elasticsearch/stable 1.0.4-6 all
      Horde ElasticSearch client

    prometheus-elasticsearch-exporter/stable 1.1.0+ds-2+b5 amd64
      Prometheus exporter for various metrics about Elasticsearch

    python-django-haystack-doc/stable 3.0-1 all
      modular search for Django (Documentation)

    python-elasticsearch-curator-doc/stable 5.8.1-1 all
      Python library for managing Elasticsearch time-series indices (documentation)

    python-elasticsearch-doc/stable 7.1.0-3 all
      Python client for Elasticsearch (Documentation)

    python3-boto/stable 2.49.0-3 all
      Python interface to Amazon's Web Services - Python 3.x

    python3-django-haystack/stable 3.0-1 all
      modular search for Django (Python version)

    python3-elasticsearch/stable 7.1.0-3 all
      Python client for Elasticsearch (Python3 version)

    python3-elasticsearch-curator/stable 5.8.1-1 all
      Python 3 library for managing Elasticsearch time-series indices

    python3-eliot/stable 1.11.0-1 all
      logging library for Python that tells you why things happen

    r-cran-glmnet/stable 4.1-2 amd64
      Lasso and Elastic-Net Regularized Generalized Linear Models

    resource-agents/stable 1:4.7.0-1 amd64
      Cluster Resource Agents

    rheolef/stable 7.1-6 amd64
      efficient Finite Element environment

    rheolef-doc/stable 7.1-6 all
      efficient Finite Element environment - documentation

    rsyslog-elasticsearch/stable,stable-security 8.2102.0-2+deb11u1 amd64
      Elasticsearch output plugin for rsyslog

    ruby-amazon-ec2/stable 0.9.17-3.1 all
      Ruby library for accessing Amazon EC2

    ruby-elasticsearch/stable 6.8.2-2 all
      Ruby client for connecting to an Elasticsearch cluster

    ruby-elasticsearch-api/stable 6.8.2-2 all
      Ruby implementation of the Elasticsearch REST API

    ruby-elasticsearch-model/stable 7.0.0-2 all
      ActiveModel/Record integrations for Elasticsearch

    ruby-elasticsearch-rails/stable 7.1.1-2 all
      Ruby on Rails integrations for Elasticsearch

    ruby-elasticsearch-transport/stable 6.8.2-2 all
      low-level Ruby client for connecting to Elasticsearch

    ruby-rails-assets-jakobmattsson-jquery-elastic/stable 1.6.11~dfsg-1.1 all
      jquery-elastic plugin for rails applications

    xball/stable 3.0.1-2 amd64
      Simulate bouncing balls in a window

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
