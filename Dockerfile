FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
ENV SDK_VERSION="0.11.1"
ENV ZEPHYR_TOOLCHAIN_VARIANT=zephyr ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk-${SDK_VERSION}
ENV PATH=$PATH:/opt/xtensa-lx106-elf/bin
ENV ESP_IDF_PATH=/opt/ESP8266_RTOS_SDK

RUN apt update; apt install -y vim && \

# FOR Zephyr
RUN apt update; apt install --no-install-recommends -y \
	git cmake ninja-build gperf ccache dfu-util device-tree-compiler wget \
	python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
	make gcc gcc-multilib g++-multilib libsdl2-dev gnupg software-properties-common && \
	\
	wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add - && \
	apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && \
	apt update && apt install -y cmake && \
	pip3 install west && \
	\
	wget -O /tmp/requirements.txt https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/master/scripts/requirements.txt && \
	pip3 install -r /tmp/requirements.txt && \
	\
	wget -O /tmp/sdk.run https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${SDK_VERSION}/zephyr-sdk-${SDK_VERSION}-setup.run && \
	chmod +x /tmp/sdk.run && \
	/tmp/sdk.run -- -y -d /opt/zephyr-sdk-${SDK_VERSION}
	#rm /tmp/requirements.txt /tmp/sdk.run

# ESP toolchain
RUN apt update; apt install -y git wget flex bison gperf python python-pip \
	python-setuptools python-serial python-click python-cryptography \
	python-future python-pyparsing python-pyelftools cmake ninja-build \
	ccache libffi-dev libssl-dev unzip && \
	\
	wget -O /tmp/esp-toolchain.zip https://github.com/espressif/ESP8266_RTOS_SDK/releases/download/v3.3-rc1/ESP8266_RTOS_SDK-v3.3-rc1.zip && \
	unzip /tmp/esp-toolchain.zip && \
	mv ESP8266_RTOS_SDK /opt && \
	\
	wget -O /tmp/esp-toolchain.tar.gz https://dl.espressif.com/dl/xtensa-lx106-elf-linux32-1.22.0-100-ge567ec7-5.2.0.tar.gz && \
	tar xzf /tmp/esp-toolchain.tar.gz && \
	mv xtensa-lx106-elf /opt
