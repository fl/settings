Settings
========

Dieses Projekt sammelt Artikel zu Einstellungen für Anwendungen und Betriebssysteme in allen Formen und Farben. Standard für die Linux-Beispiele ist Debian GNU/Linux, OS-Sprache Englisch. Tastaturbelegung? Das darf man wirklich so machen wie man es am liebsten mag. Just saying' - meine persönliche Vorliebe fuer das us-en Layout hat `Gründe`_ .

Die Dokumente werden im Format `reStructuredText`_ (reST) geschrieben und mit  `Sphinx`_ in eine statische Webseite übersetzt. Das ist im Artikel `Mit Sphinx dokumentieren`_ beschrieben.

Bereits verfügbare Artikel:

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

.. _Gründe: https://youtrack.jetbrains.com/issue/JBR-216/On-German-Keyboard-shortcut-for-Code-Comment-with-Line-Comment-doesnt-work
.. _reStructuredText: https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html
.. _Teil des docutils-Pakets: https://docutils.sourceforge.io/index.html
.. _Ziel von reST: https://docutils.sourceforge.io/docs/ref/rst/introduction.html#goals
.. _Sphinx: https://www.sphinx-doc.org/
.. _Mit Sphinx dokumentieren: stacks/sphinx-doc.html
