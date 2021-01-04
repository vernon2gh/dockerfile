FROM ubuntu:18.04

RUN apt update

#### x86_64 ####
RUN apt install -y gcc make flex bison libncurses-dev libssl-dev bc libelf-dev file g++ patch wget cpio unzip rsync python3 perl qemu

#### arm64 ####
RUN cd /opt \
	&& wget https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/aarch64-linux-gnu/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz \
	&& tar -Jxvf gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz \
	&& echo "export PATH=\$PATH:/opt/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin" >> ~/.bashrc \
	&& rm -fr *.tar.xz
