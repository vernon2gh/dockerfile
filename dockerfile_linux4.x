FROM ubuntu:16.04

RUN apt-get update

#### x86_64 ####
RUN apt-get install -y gcc make libncurses5-dev bc g++ patch wget cpio python unzip rsync bzip2 perl qemu xz-utils

# 使用apt安装的gdb，执行时会出现Remote 'g' packet reply is too long错误，所以修改gdb源码，然后安装gdb
COPY patch/gdb/gdb_7_8.patch /
RUN wget http://ftp.gnu.org/gnu/gdb/gdb-7.8.tar.xz \
	&& tar -xf gdb-7.8.tar.xz \
	&& cd gdb-7.8/ \
	&& mv /gdb_7_8.patch . \
	&& patch -p1 < gdb_7_8.patch \
	&& ./configure \
	&& make \
	&& make install \
	&& cd / \
	&& rm -fr gdb-7.8*

#### arm64 ####
RUN cd /opt \
	&& wget https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/aarch64-linux-gnu/gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz \
	&& tar -Jxvf gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz \
	&& echo "export PATH=\$PATH:/opt/gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu/bin/" >> ~/.bashrc \
	&& rm -fr *.tar.xz
