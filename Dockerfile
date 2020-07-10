# docker build -t ctf_pwn:ubuntu18.04 .
# docker run --rm -v $PWD:/pwd --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d --name ctf_pwn -i ctf_pwn:ubuntu18.04
# docker exec -it ctf_pwn /bin/bash

FROM ubuntu:18.04

COPY sources.list /etc/apt/sources.list

ENV LC_CTYPE C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ Asia/Shanghai

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    cmake \
    ipython3 \
    vim \
    net-tools \
    iputils-ping \
    libffi-dev \
    libssl-dev \
    python3-dev \
    python3-pip \
    build-essential \
    ruby \
    ruby-dev \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    gdb \
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    gawk \
    file \
    python3-distutils \
    bison \
    tzdata --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN apt-get install -y build-essential jq strace ltrace curl wget rubygems gcc dnsutils netcat gcc-multilib net-tools vim gdb gdb-multiarch python python3 python3-pip python3-dev libssl-dev libffi-dev wget git make procps libpcre3-dev libdb-dev libxt-dev libxaw7-dev python-pip libc6:i386 libncurses5:i386 libstdc++6:i386

RUN echo "now pip things"

RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN pip install capstone requests pwntools r2pipe ropgadget && \
    pip3 install pwntools keystone-engine unicorn capstone ropper

RUN mkdir /tools
RUN cd /tools  && git clone https://gitee.com/Z3R3F/pwndbg.git && cd pwndbg && git checkout stable && ./setup.sh && \
gem install one_gadget
