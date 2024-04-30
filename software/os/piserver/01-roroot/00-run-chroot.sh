# Disable Chrome caching to disk
cat <<EOF>/etc/chromium.d/99-piserver-disable-cache
export CHROMIUM_FLAGS="$CHROMIUM_FLAGS --disk-cache-dir=/dev/null --disk-cache-size=1"
EOF

ln -sf /proc/self/mounts /etc/mtab

# Disable resizing on first boot
rm -f /etc/init.d/apply_noobs_os_config /etc/rc2.d/S01apply_noobs_os_config \
    /etc/init.d/resize2fs_once /etc/rc3.d/resize2fs_once

sed -i 's# init=\S\+##g' /boot/firmware/cmdline.txt
sed -i 's# fsck.repair=yes##g' /boot/firmware/cmdline.txt
sed -i 's# rootfstype=ext4##g' /boot/firmware/cmdline.txt

# No point in saving random seed on read-only system
systemctl disable systemd-random-seed.service
systemctl disable regenerate_ssh_host_keys.service

# systemd-tmpfiles-setup should not try to change files on read-only file system
rm -f /usr/lib/tmpfiles.d/dbus.conf /usr/lib/tmpfiles.d/debian.conf

if [ -f /usr/lib/tmpfiles.d/legacy.conf ]; then
    sed -i 's@L /var/lock @#L /var/lock @g' /usr/lib/tmpfiles.d/legacy.conf
fi

if [ -d /var/lib/dbus ]; then
    ln -sf /etc/machine-id /var/lib/dbus/machine-id
fi

# Remove dphys-swapfile and logrotate
apt-get purge -y -q dphys-swapfile logrotate

systemctl disable sshswitch.service

raspi-config nonint do_overlayfs 0

# Allow initramfs updates
sed -i 's/^update_initramfs=.*/update_initramfs=all/' /etc/initramfs-tools/update-initramfs.conf

# Update initramfs (required to fix NFSv4 support and overlayfs)
update-initramfs -c -v -k all