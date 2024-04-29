#################################
Virtual machines als Testumgebung
#################################

Damit wir unsere eigene Maschine nicht mit Tests und Versuchen kaputt-konfigurieren, und damit die Tests jeweils von einer stabilen, immer gleichen Basis beginnen, verwenden wir virtuelle Maschinen (VMs). Diese VMs koennen im vSphere-Cluster laufen, im OpenStack Cluster, oder auf Linux-hosts die als Hypervisor konfiguriert sind z.B. mit KVM/QEMU oder LXC. Die Begriffe aus der VMWare-Welt gelten hier: eine VM wird als "guest" bezeichnet, und ein Server, auf dem die VM laeuft als "host" oder "Hypervisor". Die Software, die dem host ermoeglicht VMs zu betreiben nennt man Hypervisor. Die Rolle ist nicht von der Groesse abhaengig, auch das eigene Notebook kann host sein, wenn die CPU Virtualisierung unterstuetzt, die features im BIOS aktiviert sind, und Hypervisor-Software installiert und konfiguriert ist.

Zur Verwaltung von host und guest verwenden wir `libvirt`_, und das dazu passende GUI-Frontend `virt-manager`_. Dazu bereiten wir unser Linux-Notebook als host vor (mit Hypervisor-Software), und verwenden dann virt-manager um den (lokalen) host zu konfigurieren, und (lokale) VMs anzulegen und zu verwalten.

But wait, there's more! `libvirt`_ kann noch mehr als nur das lokale Notebook steuern: die Liste der `unterstuetzten Hypervisor-Software`_ ist lang und umfasst auch VMware vSphere - wir sollten also technisch in der Lage sein, mit libvirt das `vCenter fernzusteuern`_, und zwar sowohl mit der Kommandozeile und *virsh* als auch mit dem klicki-bunti *virt-manager* GUI.



************
Vorbereitung
************

Um das lokale Notebook (Debian 12) als QEMU-Hypervisor verwenden zu koennen, installieren wir die Hypervisor-Client-software und die dependencies.::

    apt install virt-manager libvirt-clients-qemu genisoimage

Mit der Installation werden zwei neue Gruppen angelegt:

* libvirt:x:125:
* libvirt-qemu:x:64055:libvirt-qemu

Der Benutzer, der virt-manager verwenden und sich am lokalen QEMU/KVM Hyoervisor anmelden will, muss in der Gruppe libvirt sein. Mit ``usermod`` passen wir als ``root`` die Gruppenzugehoerigkeit an::

    isabell@stardust:~# usermod -a -G libvirt isabell
    isabell@stardust:~# id isabell
    uid=1042(isabell) gid=1042(isabell) groups=1042(isabell),125(libvirt)

Die Gruppenzugehoerigkeit wird bei der Anmeldung festgelegt, deswegen jetzt von der Desktop-Session einmal abmelden und wieder anmelden, dann sollte die neue Gruppe sichtbar sein, z.B. in einem gestarteten Terminal.

*********************************
Virtualisierungs-GUI virt-manager
*********************************

====================
virt-manager starten
====================

virt-manager ist installiert, wir sind in der Gruppe libvirt, dann kann es losgehen. Je nach Desktop-Umgebung starten wir den virt-manager ueber das Applikations-Menue, oder auch direkt aus der Shell. Das main window von virt-manager wird angezeigt, mit 2 Spalten:

* *Name*: Name des Hypervisors (Freitext)
* *CPU Usage*: Plot der CPU-Auslastung (wenn der Hypervisor connected ist)

die angezeigten Spalten werden im Menue  View -> Graph angepasst.

====================
Hypervisor verbinden
====================

Um einen neuen Hypervisor mit dem virt-manager zu verwalten, legen wir einen neuen connection entry an, im Menue File -> Add Connection.. Fuer entfernte hosts kann virt-manager einen SSH-Tunnel nutzen (checkbox "Connect to remote host over SSH"). Unser lokaler host braucht keinen SSH-Tunnel, und schlaegt als URI vor ``qemu:///system`` wenn wir im dropdown-Menue QEMU/KVM auswaehlen. Ein "permission denied" bei dieser lokalen Verbindung liegt meistens daran dass der user, der den virt-manager ausfuehrt, nicht in der Gruppe libvirt st.

Wenn der Eintrag fuer die lokale Maschine als Hypervisor vom Typ QEMU/KVM angelegt ist, und virt-manager *connected* ist. kann man zu diesem Hypervisor gehoerende Einstellungen bearbeiten: Menue Edit -> Connection Details oder Kontext-Klick -> Details.

Das "Connection Details" Fenster hat die Tabs

* Overview
* Virtual Networks
* Storage

all diese Einstellungen kann man sowohl hier als auch mit *virsh* steuern. Um eine VM zu starten, brauchen wir mindestens ein aktives virtual network, und einen aktiven storage pool, in dem unser user schreiben darf.

Durch das "Autoconnect" Haekchen in den connection details ist pro connection entry steuerbar ob bei jedem Start des virt-manager automatisch die Verbindung aufgebaut wird. Bei remote hosts ist da nicht immer gewuenscht, z.B. wenn man dazu erst ein VPN starten muss.

************************
Hypervisor-Einstellungen
************************

=======================
Virtual Machine Network
=======================

default: ``virbr0``
Netzwerk 192.168.122.0/24, mit eigenem DHCP-Server fuer 192.168.122.2 - 192.168.122.254, verbunden mit dem host ueber ein (hiding) NAT gateway.

=======================
Virtual Machine Storage
=======================

default: pool /var/lib/libvirt/images, type directory

Debian Cloud image
^^^^^^^^^^^^^^^^^^

Das Debian-Projekt stellt disk images zur Verfuegung, die ein vorinstalliertes Debian enthalten. Diese "cloud images" liegen nach Debian-Versionen sortiert https://cloud.debian.org/images/cloud/

Fuer unsere Test-VMs verwenden wir images fuer bullseye (Debian 11) und bookworm (Debian 12)::

    wget -c https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-generic-amd64.qcow2

    wget -c https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2

Virtual disk mit "backing device"
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Fuer den storage der virtual machines verwenden wir virtual block devices, die fuer den Hypervisor ein file im storage pool sind, und von QEMU der VM als block device praesentiert werden. Damit wir identische blocks nur einmal speichern muessen, verwenden wir ein master image, und die "copy on write" (COW) Methode, sobald die VM einen blick auf dem device aendert und zurueckschreiben moechte. Es kann mehr als ein device geben, das read-only verwendet wird, zusammen ergeben sie die "backing chain". Wir beginnen mit einem device als "backing device"::

    virsh vol-create-as \
      "$POOL" "$DISK" \
      10G \
      --allocation 5G \
      --format qcow2 \
      --backing-vol "$BACKINGDISK" \
      --backing-vol-format qcow2

**********
VM anlegen
**********

Mit ``create-debian.sh <Name der virtual machine>`` legen wir eine VM an. Unsere benutzerspezifischen Daten speichern wir im cloud-init Format, ``virt-install`` erstellt daraus ein ISO-Image und haengt es beim ersten Start an die VM an.

.. Links
.. _virt-manager: https://virt-manager.org
.. _libvirt: https://libvirt.org
.. _unterstuetzten Hypervisor-Software: https://libvirt.org/drivers.html#hypervisor-drivers
.. _vCenter fernzusteuern: https://libvirt.org/drvesx.html
.. _disk image chain: https://libvirt.org/kbase/backing_chains.html
