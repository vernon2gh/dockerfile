FROM ubuntu:14.04

RUN apt-get update

#### x86_64 ####
RUN apt-get install -y gcc g++ make libncurses-dev qemu rsync patch wget unzip bc xz-utils

# buildroot编译x86_64 rootfs需要32位库
RUN dpkg --add-architecture i386 \
	&& apt update \
	&& apt-get install -y libc6:i386 libstdc++6:i386 zlib1g:i386

# 使用apt install gdb会出现Remote 'g' packet reply is too long错误，所以修改gdb源码，然后安装gdb
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

# 默认gcc版本是4.8.4，可以编译linux kernel and buildroot，但是会出现很多warning
# 所以使用gcc-4.4版本，就可以避免此warining
# 设置默认使用gcc-4.4
# 设置默认使用g++-4.4
RUN apt-get install -y gcc-4.4 g++-4.4 \
	&& update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.4 50 \
	&& update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 40 \
	&& echo 0 | update-alternatives --config gcc \
	&& update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.4 50 \
	&& update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 40 \
	&& echo 0 | update-alternatives --config g++
