FROM mxcr.io/library/maca-c500:2.15.0.1-ubuntu18.04-amd64 as maca

FROM ubuntu:18.04

ADD sources.list /etc/apt/sources.list

RUN apt update && \
    apt install -y xz-utils tar curl jq vim sudo gdb wget git ccache pkg-config \
        python3 python3-dev python3-pip python3.8 python3.8-dev \
        libssl1.0.0 libmsgpack-dev numactl build-essential binutils lintian \
        gcc-8 g++-8 patchelf

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8

ENV PIP_MIRRORS=https://pypi.tuna.tsinghua.edu.cn/simple

RUN python3.8 -m pip install -i ${PIP_MIRRORS} -U pip wheel scikit-build setuptools
RUN python3.8 -m pip install -i ${PIP_MIRRORS} cmake
RUN python3.8 -m pip config --global set global.index-url ${PIP_MIRRORS}

# go
RUN cd /usr/local && \
    wget https://studygolang.com/dl/golang/go1.18.10.linux-amd64.tar.gz && \
    tar xzf go*.tar.gz && \
    rm -fr go*.tar.gz

# copy maca form 
COPY --from=maca /opt/maca /opt/maca

ADD setup/env /tmp/env
RUN . /tmp/env && \
    if getent group $DEV_GROUP 2>/dev/null 1>/dev/null ; then \
        echo group $DEV_GROUP already exist ; \
    elif getent group $DEV_GID 2>/dev/null 1>/dev/null ; then \
        echo group $DEV_GID already exist ; \
    else \
        groupadd -g $DEV_GID $DEV_GROUP ; \
    fi ; \
    if id $DEV_USER 2>/dev/null 1>/dev/null ; then \
        echo user $DEV_USER already exist ; \
        exit 1 ; \
    elif id $DEV_UID 2>/dev/null 1>/dev/null ; then \
        echo user $DEV_UID already exist ; \
        exit 1 ; \
    else \
        useradd -g $DEV_GID -u $DEV_UID -m -d $DEV_HOME -s /bin/bash $DEV_USER ; \
    fi && \
    echo "${DEV_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user

ENV MACA_PATH=/opt/maca
ENV CUDA_PATH=/opt/maca/tools/wcuda
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/maca/lib
ENV PATH=/usr/local/go/bin:${PATH}
