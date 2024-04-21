#!/bin/sh

POOL="vmstore"
POOLDIR="/usr/local/var/vmstore"
#BACKINGDISK="$POOLDIR/debian-11-genericcloud-amd64.qcow2"
BACKINGDISK="$POOLDIR/debian-11-generic-amd64.qcow2"

VM="$1"
DISK="$VM.qcow2"
CLOUDINITISO="$VM.cloudinit.iso"

echo "instance-id: $VM" > meta-data
echo "local-hostname: $VM" >> meta-data

# create a cloud-init ISO
genisoimage -output "$POOLDIR/$CLOUDINITISO" -V cidata \
  -r -J user-data meta-data

# create new COW volume backed with the cloud image
virsh vol-create-as \
  "$POOL" "$DISK" \
  10G \
  --allocation 5G \
  --format qcow2 \
  --backing-vol "$BACKINGDISK" \
  --backing-vol-format qcow2

virt-install \
  --connect=qemu:///system \
  --name="$VM" \
  --os-variant debian11 \
  --ram=1024 \
  --vcpus=2 \
  --import \
  --disk "$POOLDIR/$DISK" \
  --disk path="$POOLDIR/$CLOUDINITISO",device=cdrom \
  --virt-type=kvm \
  --controller usb,model=none \
  --network bridge=virbr0,model=virtio \
  --autoconsole none
