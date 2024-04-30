# NFS root (Yes, the kernel param must be rw)
sed -i 's/ROOTDEV/\/dev\/nfs nfsroot=172.16.64.171\:\/home\/science\/pi-gen\/work\/otsci\/otsci\/rootfs,vers=4.2 rw ip=dhcp logo.nologo/' /boot/firmware/cmdline.txt

#echo "overlay" >> /etc/initramfs-tools/modules

cat <<EOF>/usr/share/initramfs-tools/hooks/zz-nfs4
#!/bin/sh
[ prereqs = "$1" ] && exit
. /usr/share/initramfs-tools/hook-functions
echo "Deleting of nfsmount (${DESTDIR}/bin/nfsmount) so that copy_exec will
overwrite"
rm -f ${DESTDIR}/bin/nfsmount
copy_exec /sbin/mount.nfs /bin/nfsmount
EOF

chmod +x /usr/share/initramfs-tools/hooks/zz-nfs4

# Remove BOOTDEV and ROOTDEV from fstab
sed -i '/^[B|R]OOTDEV/d' /etc/fstab

# Disable wifi and BT
{
    echo "dtoverlay=disable-wifi"
    echo "dtoverlay=disable-bt"
} >> /boot/firmware/config.txt

# do not continously poll for SD card
echo "dtparam=sd_poll_once" >> /boot/firmware/config.txt