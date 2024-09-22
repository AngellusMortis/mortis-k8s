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
