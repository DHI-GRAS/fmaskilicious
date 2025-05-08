FROM ubuntu:22.04

LABEL maintainer.name="Casper Helms" maintainer.email="cahe@dhigroup.com"

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    curl \
    unzip \
    libxmu6 \
    openjdk-11-jdk \
    xserver-xorg

COPY Fmask_4_7_Matlab_mcr.install .
RUN chmod +x Fmask_4_7_Matlab_mcr.install && \
    ./Fmask_4_7_Matlab_mcr.install -mode silent -agreeToLicense yes && \
    rm Fmask_4_7_Matlab_mcr.install

COPY run_fmask.sh /usr/local/bin/run_fmask.sh
RUN chmod +x /usr/local/bin/run_fmask.sh

COPY run_Fmask_4_7.sh /usr/GERS/Fmask_4_7/application/run_Fmask_4_7.sh
RUN chmod +x /usr/GERS/Fmask_4_7/application/run_Fmask_4_7.sh

RUN mkdir /mnt/input-dir
RUN mkdir /mnt/output-dir

VOLUME ["/mnt/input-dir"]
VOLUME ["/mnt/output-dir"]

WORKDIR /work
RUN chmod 777 /work /mnt/output-dir

ENV MCR_CACHE_ROOT="/tmp/mcr-cache"

ENTRYPOINT ["/usr/local/bin/run_fmask.sh"]
CMD ["--help"]
