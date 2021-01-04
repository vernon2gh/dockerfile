FROM ubuntu:16.04

RUN apt-get update

#### x86_64 ####
RUN apt-get install -y gcc make libncurses5-dev bc g++ patch wget cpio python unzip rsync bzip2 perl qemu

#### arm64 ####
RUN apt-get install -y xz-utils
RUN cd /opt \
	&& wget https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/aarch64-linux-gnu/gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz \
	&& tar -Jxvf gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz \
	&& echo "export PATH=\$PATH:/opt/gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu/bin/" >> ~/.bashrc \
	&& rm -fr *.tar.xz
