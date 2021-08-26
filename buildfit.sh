touch ~/devel/logs/FIT_log.txt
printf "Creating keys and FIT image...\n\n"
#create fit folder
mkdir ~/devel/fit
cd ~/devel/fit

#write image.its file
echo '/dts-v1/;
/ {
	description = "RPi FIT Image";
	#address-cells = <2>;
	images {
		kernel-1 {
			description = "default kernel";
			data = /incbin/("Image");
			type = "kernel";
			arch = "arm64";
			os = "linux";
			compression = "none";
			load =  <0x12000000>;
			entry = <0x12000000>;
			hash-1 {
				algo = "sha256";
			};
		};
		tee-1 {
			description = "bootloader and fit image";
			data = /incbin/("armstub8.bin");
			type = "standalone";
			arch = "arm64";
			compression = "none";
			load =  <0x08400000>;
			entry = <0x08400000>;
			hash-1 {
				algo = "sha256";
			};
		};
		fdt-1 {
			description = "device tree";
			data = /incbin/("bcm2710-rpi-3-b.dtb");
			type = "flat_dt";
			arch = "arm64";
			compression = "none";
			load = <0x01000000>;
			entry = <0x01000000>;
			hash-1 {
				algo = "sha256";
			};
		};
	};
	configurations {
		default = "config-1";
		config-1 {
			description = "default configuration";
			kernel = "kernel-1";
			loadables = "tee-1";
			fdt = "fdt-1";
			signature-1 {
				algo = "sha256,rsa2048";
				key-name-hint = "dev";
				sign-images = "fdt", "kernel", "loadables";
			};
		};
	};
};' > image.its

#symlink files for mkimage
ln -s ../optee/linux/arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b.dtb
ln -s ../optee/linux/arch/arm64/boot/Image
ln -s ../optee/trusted-firmware-a/build/rpi3/debug/armstub8.bin
cp ../optee/linux/arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b.dtb bcm2710-rpi-3-b-pubkey.dtb

#make RSA key pair
mkdir keys
openssl genrsa -F4 -out keys/dev.key 2048 &>> ~/devel/logs/FIT_log.txt
openssl req -batch -new -x509 -key keys/dev.key -out keys/dev.crt &>> ~/devel/logs/FIT_log.txt
#create signed FIT image
../optee/u-boot/tools/mkimage -f image.its -K bcm2710-rpi-3-b-pubkey.dtb -k keys -r image.fit &>> ~/devel/logs/FIT_log.txt

