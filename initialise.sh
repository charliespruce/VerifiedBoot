rm -rf ~/devel ~/bin
mkdir -p ~/devel/optee
mkdir -p ~/devel/logs
touch ~/devel/logs/prerequisites_log.txt
touch ~/devel/logs/repo_log.txt
touch ~/devel/logs/compilation_log.txt

#install prerequisites
printf "\nInstalling prerequisites...\n\n"
sudo add-apt-repository universe &>> ~/devel/logs/prerequisites_log.txt
sudo apt-get install --yes android-tools-adb android-tools-fastboot autoconf     automake bc bison build-essential cscope curl device-tree-compiler     expect flex ftp-upload gdisk iasl libattr1-dev libcap-dev     libfdt-dev libftdi-dev libglib2.0-dev libhidapi-dev libncurses5-dev     libpixman-1-dev libssl-dev libtool make     mtools netcat python-crypto python-serial python-wand python3-pycryptodome unzip uuid-dev     xdg-utils xterm xz-utils zlib1g-dev git &>> ~/devel/logs/prerequisites_log.txt
sudo dpkg --add-architecture i386 &>> ~/devel/logs/prerequisites_log.txt

#set up repo tool
printf "Setting up Google repo tool...\n\n"
mkdir -p ~/bin
PATH=~/bin:$PATH
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
git config --global user.name "Charlie Spruce" &>> ~/devel/logs/repo_log.txt
git config --global user.email "charlie@charliespruce.com" &>> ~/devel/logs/repo_log.txt

#get OP-TEE source code
printf "\nDownloading OP-TEE source code...\n\n"
cd ~/devel/optee
yes y | repo init -u https://github.com/OP-TEE/manifest.git -m rpi3.xml -b 3.14.0 &>> ~/devel/logs/repo_log.txt
cd .repo/repo
git checkout v1.13.11 &>> ~/devel/logs/repo_log.txt
cd ~/devel/optee
yes y | repo init -u https://github.com/OP-TEE/manifest.git -m rpi3.xml -b 3.14.0 &>> ~/devel/logs/repo_log.txt
repo sync -j $( nproc --all ) &>> ~/devel/logs/repo_log.txt
cd build

#make the OPTEE package
printf "Compiling the OP-TEE build...\n\n"
make toolchains -j $( nproc --all ) &>> ~/devel/logs/compilation_log.txt
make -j $( nproc --all ) &>> ~/devel/logs/compilation_log.txt
