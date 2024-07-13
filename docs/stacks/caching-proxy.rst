##################################
Caching Proxy um traffic zu sparen
##################################

**********************************
Squid installieren + konfigurieren
**********************************

Mit ``apt`` installieren::

    apt update
    apt upgrade
    apt install squid

In der voreingestellten Konfiguration horcht squid auf private Netzwerke (RFC1918)::

    acl localnet src 0.0.0.1-0.255.255.255	# RFC 1122 "this" network (LAN)
    acl localnet src 10.0.0.0/8		# RFC 1918 local private network (LAN)
    acl localnet src 100.64.0.0/10		# RFC 6598 shared address space (CGN)
    acl localnet src 169.254.0.0/16 	# RFC 3927 link-local (directly plugged) machines
    acl localnet src 172.16.0.0/12		# RFC 1918 local private network (LAN)
    acl localnet src 192.168.0.0/16		# RFC 1918 local private network (LAN)
    acl localnet src fc00::/7       	# RFC 4193 local private network range
    acl localnet src fe80::/10      	# RFC 4291 link-local (directly plugged) machines

    acl SSL_ports port 443
    acl Safe_ports port 80		# http
    acl Safe_ports port 21		# ftp
    acl Safe_ports port 443		# https
    acl Safe_ports port 70		# gopher
    acl Safe_ports port 210		# wais
    acl Safe_ports port 1025-65535	# unregistered ports
    acl Safe_ports port 280		# http-mgmt
    acl Safe_ports port 488		# gss-http
    acl Safe_ports port 591		# filemaker
    acl Safe_ports port 777		# multiling http
    acl CONNECT method CONNECT

    http_access deny !Safe_ports

    http_access deny CONNECT !SSL_ports

    http_access allow localhost manager
    http_access deny manager

    include /etc/squid/conf.d/*

    http_access allow localhost

    http_access deny all

    http_port 3128

    coredump_dir /var/spool/squid

    refresh_pattern ^ftp:		1440	20%	10080
    refresh_pattern ^gopher:	1440	0%	1440
    refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
    refresh_pattern .		0	20%	4320

Bevor wir die Konfiguration veraendern, stellen wir das Konfig-File unter lokale, file-basierte Versionskontrolle. Dazu installieten wir erst das Paket ``rcs``::

    Reading package lists... Done
    Building dependency tree... Done
    Reading state information... Done
    The following NEW packages will be installed:
      rcs
    0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
    Need to get 216 kB of archives.
    After this operation, 575 kB of additional disk space will be used.
    Get:1 http://deb.debian.org/debian bullseye/main amd64 rcs amd64 5.10.0-1 [216 kB]
    Fetched 216 kB in 23s (9257 B/s)
    Selecting previously unselected package rcs.
    (Reading database ... 28001 files and directories currently installed.)
    Preparing to unpack .../rcs_5.10.0-1_amd64.deb ...
    Unpacking rcs (5.10.0-1) ...
    Setting up rcs (5.10.0-1) ...
    Processing triggers for man-db (2.9.4-2) ...
    root@proxy:~#

RCS ist der `Urvater der textbasierten Versionsverwaltung`_ , und stellt fuer die verschiedenen Aufgaben jeweils eine Befehle zur Verfuegung. Die wichtigsten sind

- ``ci`` files einchecken
- ``co`` Versionen von files auschecken
- ``ident`` Versions-Informationen anzeigen (auch wenn sie in Sprachenabhaengige Programmstrukturen aingebunden sind
- ``rlog`` Versionsgeschichte mit Log-Informationen anzeigen
- ``rcsdiff`` Unterschiede zwischen Versionen anzeigen

Wir erzeugen eine ``initial version`` (immer 1.1) des files durch einen ersten checkout::

    root@proxy:/etc/squid# ci -l squid.conf
    squid.conf,v  <--  squid.conf
    enter description, terminated with single '.' or end of file:
    NOTE: This is NOT the log message!
    >> initial version from install
    >> .
    initial revision: 1.1
    done

und koennen da froehlich aendern, weil wir wissen dass wir mit ``rcsdiff`` zuverlaessig die Unterschiede sehen koennen. Wir passen die maximum_object_size an auf > 10G damit wir auch haesslich grosse ISOs cachen (looking at you, `Windows Developer VMs`_ !). Und wir legen ein cache directory an damit unser cache auch reboots ueberlebt. nach der Anpassung des config-files muss das neue cache_dir noch vorbereitet werden::



Die Konfiguration in ``/etc/squid/squid.conf`` anpassen:

=====================
Squid installieren L2
=====================


^^^^^^^^^^^^^^^^^^^^^
Squid installieren L3
^^^^^^^^^^^^^^^^^^^^^

.. _Urvater der textbasierten Versionsverwaltung: https://www.gnu.org/software/rcs/tichy-paper.pdf
.. _Windows Developer VMs: https://developer.microsoft.com/en-us/windows/downloads/virtual-machines/
