#############
Der ELK-Stack
#############

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

Wir beginnen mit der Installation von Elasticsearch. Dazu verwenden wir eine Debian 12 (Bookworkm) VM (Standard-Installation, in der Paket-Auswahl *tasksel* nur "SSH Server" ausgewaehlt).





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
