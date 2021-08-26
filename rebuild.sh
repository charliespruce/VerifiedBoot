touch ~/devel/logs/rebuild_log.txt
printf "Rebuilding binaries to accept FIT image...\n\n"
#build U-Boot with FIT image
echo 'boot_fit=bootm ${fit_addr}
fdt_addr_r=0x01000000
fit_addr=0x02000000
fdtfile=bcm2710-rpi-3-b-plus.dtb
load_fit=fatload mmc 0:1 ${fit_addr} image.fit
mmcboot=run load_fit; run set_bootargs_tty set_bootargs_mmc set_common_args; run boot_fit' &>> ~/devel/optee/build/rpi3/firmware/uboot.env.txt

#build U-Boot env file
cd ~/devel/optee/build
make -j $( nproc --all ) EXT_DTB=../../fit/bcm2710-rpi-3-b-pubkey.dtb arm-tf u-boot-env &>> ~/devel/logs/rebuild_log.txt

#configure FIT image support
echo 'CONFIG_OF_CONTROL=y
CONFIG_FIT=y
CONFIG_FIT_SIGNATURE=y
CONFIG_RSA=y
CONFIG_IMAGE_FORMAT_LEGACY=y
CONFIG_FIT_VERBOSE=y
CONFIG_SHA1=y
CONFIG_SHA256=y
CONFIG_OF_LIBFDT=y' &>> ~/devel/optee/u-boot/configs/rpi_3_defconfig

#support larger FIT image
sed -i '84 i #define CONFIG_SYS_BOOTM_LEN (16 << 20)' ~/devel/optee/u-boot/include/configs/rpi.h

#build with FIT image
cd ~/devel/optee/build
make -j $( nproc --all )  u-boot-clean arm-tf-clean u-boot-env-clean &>> ~/devel/logs/rebuild_log.txt
make -j $( nproc --all ) EXT_DTB=../../fit/bcm2710-rpi-3-b-pubkey.dtb arm-tf u-boot-env u-boot &>> ~/devel/logs/rebuild_log.txt
