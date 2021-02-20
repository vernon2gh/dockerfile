FROM ubuntu:14.04

RUN apt-get update

#### x86_64 ####
RUN apt-get install -y gcc g++ make libncurses-dev qemu bc rsync g++ patch wget unzip

# 使用apt安装的gdb，执行时会出现Remote 'g' packet reply is too long错误，所以修改gdb源码，然后安装gdb
COPY patch/gdb/gdb_7_8.patch /
RUN wget http://ftp.gnu.org/gnu/gdb/gdb-7.8.tar.xz \
	&& tar -xf gdb-7.8.tar.xz \
	&& cd gdb-7.8/ \
	&& mv /gdb_7_8.patch . \
	&& patch -p1 < gdb_7_8.patch \
	&& ./configure \
	&& make \
	&& sudo make install \
	&& cd / \
	&& rm -fr gdb-7.8*

#### arm64 ####
RUN apt-get install -y pkg-config zlib1g-dev libglib2.0-dev autoconf libtool xz-utils
RUN cd /opt \
	&& wget https://releases.linaro.org/components/toolchain/binaries/4.9-2016.02/aarch64-linux-gnu/gcc-linaro-4.9-2016.02-x86_64_aarch64-linux-gnu.tar.xz \
	&& tar -Jxvf gcc-linaro-4.9-2016.02-x86_64_aarch64-linux-gnu.tar.xz \
	&& echo "export PATH=\$PATH:/opt/gcc-linaro-4.9-2016.02-x86_64_aarch64-linux-gnu/bin/" >> ~/.bashrc \
	&& rm -fr *.tar.xz \
	&& wget https://download.qemu.org/qemu-2.4.1.tar.bz2 \
	&& tar -jxvf qemu-2.4.1.tar.bz2 \
	&& cd qemu-2.4.1 \
	&& ./configure --target-list=aarch64-softmmu \
	&& make \
	&& cp aarch64-softmmu/qemu-system-aarch64 /usr/bin/ \
	&& cd /opt/ \
	&& rm -fr qemu-2.4.1*
