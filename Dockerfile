FROM quay.io/baselibrary/ubuntu:14.04
# docker build -t ngs-tl:latest .
USER root

RUN apt-get update && apt-get -y upgrade && \
	apt-get install -y build-essential wget \
		libncurses5-dev zlib1g-dev libbz2-dev liblzma-dev libcurl3-dev git r-base r-base-dev && \
	apt-get clean && apt-get purge && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install mosdepth
RUN wget "https://github.com/brentp/mosdepth/releases/download/v0.3.2/mosdepth"
RUN cp ./mosdepth /usr/local/bin/
RUN chmod a+x /usr/local/bin/mosdepth

# install bedtools
RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools.static.binary
RUN cp ./bedtools.static.binary /usr/local/bin/bedtools
RUN chmod a+x /usr/local/bin/bedtools

VOLUME /tmp

WORKDIR /tmp

# install telseq prereqs
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


WORKDIR /usr/src

# install samtools

RUN wget https://github.com/samtools/samtools/releases/download/1.16.1/samtools-1.16.1.tar.bz2 && \
	tar jxf samtools-1.16.1.tar.bz2 && \
	rm samtools-1.16.1.tar.bz2 && \
	cd samtools-1.16.1 && \
	./configure --prefix $(pwd) && \
	make

ENV PATH=${PATH}:/usr/src/samtools-1.16.1 

WORKDIR /usr/src


WORKDIR /app
# https://stackoverflow.com/questions/36996046/how-to-prevent-dockerfile-caching-git-clone
# prevent cached git clone if repo main is updated
# Github rate limits quite often
# ADD https://api.github.com/repos/PankratzLab/NGS-TL/git/refs/heads/main version.json
# use time instead
ADD https://worldtimeapi.org/api/ip time.tmp

RUN git clone https://github.com/PankratzLab/NGS-TL.git
WORKDIR /app/NGS-TL


# RUN groupadd -r -g 1000 ubuntu && useradd -r -g ubuntu -u 1000 ubuntu
# USER ubuntu


CMD ["/bin/bash"]