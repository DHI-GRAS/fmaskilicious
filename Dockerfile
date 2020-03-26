FROM ubuntu:18.04

MAINTAINER Dion Häfner <dimh@dhigroup.com>

USER root

RUN apt-get update && \
    apt-get install -y \
      'curl' \
      'unzip' \
      'libxmu6' \
      'openjdk-11-jdk' \
      'xserver-xorg'

COPY Fmask_4_1_Linux.install .
RUN chmod +x Fmask_4_1_Linux.install && \
    ./Fmask_4_1_Linux.install -mode silent -agreeToLicense yes && \
    rm Fmask_4_1_Linux.install

COPY run_fmask.sh /usr/local/bin/run_fmask.sh
RUN chmod +x /usr/local/bin/run_fmask.sh

VOLUME ["/mnt/input-dir"]
VOLUME ["/mnt/output-dir"]

WORKDIR /work
RUN chmod 777 /work /mnt/output-dir

ENV MCR_CACHE_ROOT="/tmp/mcr-cache"

ENTRYPOINT ["/usr/local/bin/run_fmask.sh"]
CMD ["--help"]