touch ~/devel/logs/format_log.txt
printf "Building file systems on SD card...\n\n"

#format the SD
#printf...\n\nd...\n\np...\n\n...\n\n+1...\n\nn...\n\n2...\n\nt...\n\ne...\n\n1...\n\n" | fdisk $SD_device

#build file systems on partitions
sudo umount -a &>> ~/devel/logs/format_log.txt
yes y | sudo mkfs.vfat -F16 -n BOOT $11 &>>  ~/devel/logs/format_log.txt
mkdir -p /media/boot
sudo mount $11 /media/boot
cd /media
gunzip -cd ~/devel/optee/build/../out-br/images/rootfs.cpio.gz | sudo cpio -idmv "boot/*" &>> ~/devel/logs/format_log.txt
sudo umount boot

yes y | sudo mkfs.ext4 -L rootfs $12 &>> ~/devel/logs/format_log.txt
mkdir -p /media/rootfs
sudo mount $12 /media/rootfs
cd rootfs
gunzip -cd ~/devel/optee/build/../out-br/images/rootfs.cpio.gz | sudo cpio -idmv &>>~/devel/logs/format_log.txt
sudo rm -rf /media/rootfs/boot/*
cd .. && sudo umount rootfs

sudo mount $11 /media/boot
cd /media/boot
sudo cp ~/devel/optee/out/uboot.env .
sudo cp ~/devel/fit/image.fit .
sudo cp ~/devel/optee/trusted-firmware-a/build/rpi3/debug/armstub8.bin .
sudo rm kernel8.img
cd .. && sudo umount boot
