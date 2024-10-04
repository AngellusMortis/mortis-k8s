# install node-shell
kubectl krew index add kvaps https://github.com/kvaps/krew-index
kubectl krew install kvaps/node-shell

# create temp namespace to work in
kubectl create ns temp
kubectl label ns temp  pod-security.kubernetes.io/enforce=privileged
kubectl node-shell -n temp -x storage-1


# mount host devices and binaries
mount -o bind /host/dev /dev
mount -o bind /host/usr/local /usr/local

# get needed libraries for zpool
ldd /usr/local/sbin/zpool

# mount libs
touch /lib/libuuid.so.1
touch /lib/libblkid.so.1

mount -o bind /host/lib/libuuid.so.1 /lib/libuuid.so.1
mount -o bind /host/lib/libblkid.so.1 /lib/libblkid.so.1

# get block size
blockdev --getbsz /dev/sda

4k = ashift=12
8k = ashift=13

# create pool
zpool create -f -o ashift=12 nvme \
    mirror \
        nvme-WUS4BA1A1DSP3X1_A0842047 \
        nvme-WUS4BA1A1DSP3X1_A0896281 \
    mirror \
        nvme-WUS4BA1A1DSP3X1_A08D4A67 \
        nvme-WUS4BA1A1DSP3X3_A07CD0F8


zpool create -f -o ashift=12 ssd \
    mirror \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NJ0TC01196Y \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NJ0TC01128M \
    mirror \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NJ0TC01201Y \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NJ0TC01141Z \
    mirror \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NJ0TC01184K \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NJ0TC01151N \
    mirror \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NJ0TC01140A \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NJ0TC01200P \
    mirror \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NJ0TC01199V \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NJ0TC01193E \
    mirror \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NS0W300823M \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NS0W301394T \
    mirror \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NS0W301395N \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NS0W301396L \
    mirror \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NS0W301397X \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NS0W301399D \
    mirror \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NS0W301408A \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NS0W301433R \
    mirror \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NS0W301434K \
        ata-SAMSUNG_MZ7L37T6HBLA-00A07_S722NS0W301438T


zpool status -v
zpool list


# Check for TRIM support

zpool status -t ssd
zpool set autotrim=on ssd
zpool set autotrim=on nvme


# cleanup
zpool destroy ssd


# maintainence
zpool scrub ssd


# backup ZFS
zpool create \
    -O encryption=aes-256-gcm -O keyformat=passphrase \
    -O keylocation=file:///mnt/etc/secrets/initrd/keyfile1.bin -O compression=lz4 \
    -O mountpoint=none -O xattr=sa \
    -O acltype=posixacl -o ashift=12 \
    zpool \
    raidz3 \
        ata-ST16000NM001G-2KK103_WL201ST8 \
        ata-ST16000NM001G-2KK103_WL201ZDX \
        ata-ST16000NM001G-2KK103_WL202LTV \
        ata-ST16000NM001G-2KK103_WL2095RW \
        ata-ST16000NM001G-2KK103_WL20LK51 \
        ata-ST16000NM001G-2KK103_WL20NCKY \
        ata-ST16000NM001G-2KK103_WL20R748 \
        ata-ST16000NM001G-2KK103_ZL22GD9S \
        ata-ST16000NM001G-2KK103_ZL2AA5V7 \
        ata-ST16000NM001G-2KK103_ZL2CPJQD \
        ata-ST16000NM001G-2KK103_ZL2EGJ0G \
        ata-ST16000NM001G-2KK103_ZL2EYFXP \
        ata-ST16000NM001G-2KK103_ZL2F0PYC \
        ata-ST16000NM001G-2KK103_ZL2F0SL0 \
        ata-ST16000NM001G-2KK103_ZL2F8SQF \
        ata-ST16000NM001G-2KK103_ZL2FDEQ3 \
        ata-ST16000NM001G-2KK103_ZL2FVMM9 \
        ata-ST16000NM001G-2KK103_ZL2FXTPG \
        ata-ST16000NM001G-2KK103_ZL2FZ77R \
        ata-ST16000NM001G-2KK103_ZL2FZWAG \
        ata-ST16000NM001G-2KK103_ZL2G0FPW \
        ata-ST16000NM001G-2KK103_ZL2G20QM \
        ata-ST16000NM001G-2KK103_ZL2GTXLT \
        ata-ST16000NM001G-2KK103_ZL2H8NN6 \
        ata-ST16000NM001G-2KK103_ZL2KLY96 \
        ata-ST16000NM001G-2KK103_ZL2KM5NY \
        ata-ST16000NM001G-2KK103_ZL2KMCM0 \
        ata-ST16000NM001G-2KK103_ZL2KQXTF \
        ata-ST16000NM001G-2KK103_ZL2L33Q2 \
        ata-ST16000NM001G-2KK103_ZL2LST2A \
        ata-ST16000NM001G-2KK103_ZL2M7DTT \
        ata-ST16000NM001G-2KK103_ZL2MX1NS \
        ata-ST16000NM001G-2KK103_ZL2NHYHV \
        ata-ST16000NM001G-2KK103_ZL2NN0XG \
        ata-ST16000NM001G-2KK103_ZL2NVALN \
        ata-ST16000NM001G-2KK103_ZL2NXTMN

zfs create -o mountpoint=/opt/media -o recordsize=1M -o dedup=on zpool/media
zfs create -o mountpoint=/opt/backup -o recordsize=1M -o dedup=on zpool/backup
zfs create -o mountpoint=/opt/public -o recordsize=1M -o dedup=on zpool/public
zfs create -o mountpoint=/opt/syncthing -o recordsize=1M -o dedup=on zpool/syncthing
zfs create -o mountpoint=/opt/download -o recordsize=1M -o dedup=on zpool/download

# if in install ISO
zpool export zpool
zpool import -d /dev/disk/by-id -R /mnt zpool -N
zfs load-key zpool
zfs mount -a
