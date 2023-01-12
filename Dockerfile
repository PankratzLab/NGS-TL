FROM quay.io/baselibrary/ubuntu:14.04

USER root

RUN apt-get update && apt-get -y upgrade && \
	apt-get install -y build-essential wget \
		libncurses5-dev zlib1g-dev libbz2-dev liblzma-dev libcurl3-dev && \
	apt-get clean && apt-get purge && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget "https://github.com/brentp/mosdepth/releases/download/v0.3.2/mosdepth"
RUN cp ./mosdepth /usr/local/bin/
RUN chmod a+x /usr/local/bin/mosdepth

VOLUME /tmp

WORKDIR /tmp

RUN apt-get update && \
    apt-get install -y \
        automake \
        autotools-dev \
        build-essential \
        cmake \
        libhts-dev \
        libhts0 \
        libjemalloc-dev \
        libsparsehash-dev \
        libz-dev \
        python-matplotlib \
        wget \
        zlib1g-dev

# build remaining dependencies:
# bamtools
RUN mkdir -p /deps && \
    cd /deps && \
    wget https://github.com/pezmaster31/bamtools/archive/v2.4.0.tar.gz && \
    tar -xzvf v2.4.0.tar.gz && \
    rm v2.4.0.tar.gz && \
    cd bamtools-2.4.0 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make


# build telseq
RUN mkdir -p /src && \
    cd /src && \
    wget https://github.com/zd1/telseq/archive/v0.0.1.tar.gz && \
    tar -xzvf v0.0.1.tar.gz && \
    rm v0.0.1.tar.gz && \
    cd telseq-0.0.1/src && \
    ./autogen.sh && \
    ./configure --with-bamtools=/deps/bamtools-2.4.0 --prefix=/usr/local && \
    make && \
    make install


ENV PATH=${PATH}:/usr/local/bin/


# RUN chmod a+x mosdepth



WORKDIR /usr/src

RUN wget https://github.com/samtools/samtools/releases/download/1.13/samtools-1.13.tar.bz2 && \
	tar jxf samtools-1.13.tar.bz2 && \
	rm samtools-1.13.tar.bz2 && \
	cd samtools-1.13 && \
	./configure --prefix $(pwd) && \
	make

ENV PATH=${PATH}:/usr/src/samtools-1.13 


RUN groupadd -r -g 1000 ubuntu && useradd -r -g ubuntu -u 1000 ubuntu
USER ubuntu


CMD ["/bin/bash"]