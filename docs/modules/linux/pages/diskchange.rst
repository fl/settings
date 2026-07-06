############################
Platten wechseln im ZFS-Pool
############################

Wenn Platten akputt gehen, muss man sie auswechseln. Wenn sie an einem RAID-Controller hängen, kümmert der sich drum, wenn aber den Controller im HBA-Mode betreiben und die Platten als JBOD, dann müßen wir uns schon sleber drum kümmern.

Hier ist eine Platte bereits FAULTY::

    root@sputnix:~# zpool list -v
    NAME                               SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
    pool0                             3.89T   537G  3.37T        -         -     1%    13%  1.00x  DEGRADED  -
      raidz2-0                        3.89T   537G  3.37T        -         -     1%  13.5%      -  DEGRADED
        wwn-0x5000c50070a4d50f-part4   499G      -      -        -         -      -      -      -    ONLINE
        wwn-0x5000cca043992528-part4   499G      -      -        -         -      -      -      -    ONLINE
        wwn-0x5000cca04398ff30-part4   499G      -      -        -         -      -      -      -    ONLINE
        wwn-0x5000cca04380a7fc-part4   499G      -      -        -         -      -      -      -   FAULTED
        wwn-0x5000cca0438612f0-part4   499G      -      -        -         -      -      -      -    ONLINE
        wwn-0x5000cca04396ba34-part4   499G      -      -        -         -      -      -      -    ONLINE
        wwn-0x5000cca0437a613c-part4   499G      -      -        -         -      -      -      -    ONLINE
        wwn-0x5000cca043991a48-part4   499G      -      -        -         -      -      -      -    ONLINE

Am Server selber leuchtet die Fehler-LED von einer Platte, Box 3 Bay 2. Dieser Controller ist im HBA mode, und exportiert nur die blockdevices, keine logical disks (FIXME: nicht ganz richtig, mit der hpsa man page erweitern). Welche Platte genau ist kaputt? Aus dem device name sehen wir die WWN::

    wwn-0x5000cca04380a7fc-part4   499G      -      -        -         -      -      -      -   FAULTED

Mit der WWN suchen wir die Zuordnung zum Linux device node::

    root@sputnix:~# ls -l /dev/disk/by-id/wwn-0x5000cca04380a7fc*
    lrwxrwxrwx 1 root root  9 Feb  5 21:34 /dev/disk/by-id/wwn-0x5000cca04380a7fc -> ../../sdg
    lrwxrwxrwx 1 root root 10 Feb  5 21:34 /dev/disk/by-id/wwn-0x5000cca04380a7fc-part1 -> ../../sdg1
    lrwxrwxrwx 1 root root 10 Feb  5 21:34 /dev/disk/by-id/wwn-0x5000cca04380a7fc-part2 -> ../../sdg2
    lrwxrwxrwx 1 root root 10 Feb  5 21:34 /dev/disk/by-id/wwn-0x5000cca04380a7fc-part3 -> ../../sdg3
    lrwxrwxrwx 1 root root 10 Feb  5 21:34 /dev/disk/by-id/wwn-0x5000cca04380a7fc-part4 -> ../../sdg4

/dev/sdg ist unser Problemkind. Jetzt ermitteln wir die SCSI ID, damit wir die Platte einer box/bay zuordnen koennen::

    root@sputnix:~# sg_map
    /dev/sg0
    /dev/sg1  /dev/sda
    /dev/sg2  /dev/sdb
    /dev/sg3  /dev/sdc
    /dev/sg4  /dev/sdd
    /dev/sg5  /dev/sde
    /dev/sg6  /dev/sdf
    /dev/sg7  /dev/sdg
    /dev/sg8  /dev/sdh
    /dev/sg9
    /dev/sg10  /dev/sdi

Mit dem sg_map Kommando aus den sg3-tools koennen wir die SCSI-ID zu diesem Device ermitteln::

    root@sputnix:~# sg_inq --page=0x80 /dev/sg7
    VPD INQUIRY, page code=0x80:
    00 80 00 10 20 20 20 20  20 20 20 20 4b 53 4a 38    ....        KSJ8
    53 45 57 46                                         SEWF

Unsere Platte hat also die SCSI-ID ``KSJ8SEWF``. Wo haengt die am Controller?::

    root@sputnix:~# cciss_vol_status -V -s /dev/sg0
    Controller: Smart Array P440
      Board ID: 0x21c2103c
      Logical drives: 0
      Running firmware: 7.00
      ROM firmware: 7.00
      Physical drives: 8
             connector 1I box 3 bay 5                  HP      EG0600FBVFP                                      KSJR6YPN     HPDE OK
             connector 1I box 3 bay 6                  HP      EG0600FBVFP                                      KSJNWRVF     HPDE OK
             connector 1I box 3 bay 7                  HP      EG0600FCVBK                          S0M1E1VC0000M41919Q0     HPD9 OK
             connector 1I box 3 bay 8                  HP      EG0600FBVFP                                      KSJBRU8F     HPDE OK
             connector 1I box 3 bay 4                  HP      EG0600FBVFP                                      KSJ59ERJ     HPDE OK
             connector 1I box 3 bay 3                  HP      EG0600FBVFP                                      KSJR4E9N     HPDE OK
             connector 1I box 3 bay 2                  HP      EG0600FBVFP                                      KSJ8SEWF     HPDE OK
             connector 1I box 3 bay 1                  HP      EG0600FBVFP                                      KSJR677N     HPDE OK
    /dev/sg0(Smart Array P440:0): Non-Volatile Cache status:
                       Cache configured: No

Die Platte mit der SCSI-ID KSJ8SEWF befindet sich in Box 3, Bay 2. Weil wir ordentlich sind nehmen wir sie die Partition im ZFS und im MD offline. Zuerst der ZFS Pool:::

    root@sputnix:~# zpool offline pool0 /dev/disk/by-id/wwn-0x5000cca04380a7fc-part4
    root@sputnix:~# zpool list -v
    NAME                               SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
    pool0                             3.89T   537G  3.37T        -         -     1%    13%  1.00x  DEGRADED  -
      raidz2-0                        3.89T   537G  3.37T        -         -     1%  13.5%      -  DEGRADED
        wwn-0x5000c50070a4d50f-part4   499G      -      -        -         -      -      -      -    ONLINE
        wwn-0x5000cca043992528-part4   499G      -      -        -         -      -      -      -    ONLINE
        wwn-0x5000cca04398ff30-part4   499G      -      -        -         -      -      -      -    ONLINE
        wwn-0x5000cca04380a7fc-part4   499G      -      -        -         -      -      -      -   FAULTED
        wwn-0x5000cca0438612f0-part4   499G      -      -        -         -      -      -      -    ONLINE
        wwn-0x5000cca04396ba34-part4   499G      -      -        -         -      -      -      -    ONLINE
        wwn-0x5000cca0437a613c-part4   499G      -      -        -         -      -      -      -    ONLINE
        wwn-0x5000cca043991a48-part4   499G      -      -        -         -      -      -      -    ONLINE

Jetzt die beiden RAID Devices::

    root@sputnix:~# mdadm /dev/md0 --fail /dev/disk/by-id/wwn-0x5000cca04380a7fc-part2
    root@sputnix:~# mdadm /dev/md1 --fail /dev/disk/by-id/wwn-0x5000cca04380a7fc-part3

    root@sputnix:~# cat /proc/mdstat
    Personalities : [raid1] [raid0] [raid6] [raid5] [raid4] [raid10]
    md0 : active raid1 sdd2[4] sde2[0] sdh2[7] sdg2[6](F) sda2[5] sdb2[3] sdf2[1] sdc2[2]
          2094080 blocks super 1.2 [8/7] [UUUUUU_U]

    md1 : active raid1 sdd3[4] sdg3[6](F) sdc3[2] sdb3[3] sde3[0] sdh3[7] sda3[5] sdf3[1]
          59734016 blocks super 1.2 [8/7] [UUUUUU_U]

    unused devices: <none>

Jetzt koennen wir die Platte abstecken. Das sehen wir anschliessend auch in den kernel messages::

    root@sputnix:~# dmesg | tail
    [418391.633781] md/raid1:md0: Disk failure on sdg2, disabling device.
                    md/raid1:md0: Operation continuing on 7 devices.
    [418414.942529] md/raid1:md1: Disk failure on sdg3, disabling device.
                    md/raid1:md1: Operation continuing on 7 devices.
    [418489.366233] hpsa 0000:13:00.0: SCSI status: LUN:0000000000800601 CDB:12010000040000000000000000000000
    [418489.385285] hpsa 0000:13:00.0: SCSI Status = 02, Sense key = 0x05, ASC = 0x25, ASCQ = 0x00
    [418489.403067] hpsa 0000:13:00.0: Acknowledging event: 0x80000012 (HP SSD Smart Path configuration change)
    [418489.464158] hpsa 0000:13:00.0: scsi 0:0:7:0: removed Direct-Access     HP       EG0600FBVFP      PHYS DRV SSDSmartPathCap- En- Exp=1
    [418504.722652] hpsa 0000:13:00.0: Acknowledging event: 0x80000002 (HP SSD Smart Path configuration change)
    [418504.776397] hpsa 0000:13:00.0: scsi 0:0:7:0: masked Direct-Access     HP       EG0600FBVFP      PHYS DRV SSDSmartPathCap- En- Exp=0
``