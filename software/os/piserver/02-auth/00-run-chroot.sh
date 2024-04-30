# Remove piwiz
apt-get remove -y -q piwiz

if [ -f /etc/lightdm/lightdm.conf ]; then
    # Store X authority in tmpfs instead of in home dir
    sed -i "s/#user-authority-in-system-dir=false/user-authority-in-system-dir=true/" /etc/lightdm/lightdm.conf
    # Hide user list
    sed -i "s/greeter-hide-users=false/greeter-hide-users=true/" /etc/lightdm/lightdm.conf
fi

# User Pi has no place in multi-user system
#
deluser --remove-home pi || true
delgroup pi || true

#
# Make all users part of some extra local groups when logged in through lightdm
#
sed -i '/@include common-auth/a auth       optional   pam_group.so' /etc/pam.d/lightdm

{
    echo
    echo "# Added for Piserver"
    echo "lightdm;*;*;Al0000-2400;dialout, audio, video, spi, i2c, gpio, plugdev, input"
} >> /etc/security/group.conf

cat <<EOF>/etc/security/pam_mount.conf.xml
<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE pam_mount SYSTEM "pam_mount.conf.xml.dtd">
<pam_mount>
        <debug enable="0" />
        <volume user="*" fstype="fuse" path="%(USER)@piserver:" mountpoint="/home/%(USER)"
                options="port=1022,password_stdin,UserKnownHostsFile=/dev/null,StrictHostKeyChecking=no,IdentitiesOnly=yes,IdentityFile=/dev/null,ssh_command=ssh -F /dev/null" />

        <mntoptions require="nosuid,nodev" />
        <logout wait="0" hup="0" term="0" kill="0" />
        <mkmountpoint enable="1" remove="true" />
        <fusemount>sshfs %(VOLUME) %(MNTPT) -o %(OPTIONS)</fusemount>
</pam_mount>
EOF

update-initramfs -u -v -k all