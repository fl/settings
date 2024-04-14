Settings
========

Einstellungen fuer Anwendungen und Betriebssysteme in allen Formen und Farben. Standard fuer die Linux-Beispiele ist Debian 12 "Bullseye" fuer amd64, OS-Sprache Englisch. Tastaturbelegung? Das darf man wirklich so machen wie man es am liebsten mag. Just saying' - meine persoenliche Vorliebe fuer das us-en Layout hat `Gruende`_.

Die Dokumente werden im Verzeichnis docs abgelegt, und im Format `reStructuredText`_ (reST) geschrieben, der Sprache die z.B. die Projekte Python und Sphinx als Standard fuer Dokumentation verwenden. Der reST-Parser ist `Teil des docutils-Pakets`_. Das `Ziel`_ von reST ist es, eine Syntax zu definieren, mit der in (lesbaren) Plaintext-Dokumenten Struktur beschrieben wird, die mit Hilfe von Generatoren automatisch in andere Formate uebersetzt werden kann. Konvention ist, den reST-Dokumenten die Dateierweiterung ``.rst`` zu geben (der Parser verarbeitet Dokumente mit beliebigen Dateierweiterungen).

Contents
--------
.. toctree::
   :caption: Application stacks
   :maxdepth: 1
   :glob:

   stacks/*

.. toctree::
   :caption: Linux
   :maxdepth: 1
   :glob:

   linux/*

.. toctree::
   :caption: Windows
   :maxdepth: 1
   :glob:

   windows/*

.. _Gruende: https://youtrack.jetbrains.com/issue/JBR-216/On-German-Keyboard-shortcut-for-Code-Comment-with-Line-Comment-doesnt-work
.. _reStructuredText: https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html
.. _Teil des docutils-Pakets: https://docutils.sourceforge.io/index.html
.. _Ziel: https://docutils.sourceforge.io/docs/ref/rst/introduction.html#goals

https://docutils.sourceforge.io/rst.html
