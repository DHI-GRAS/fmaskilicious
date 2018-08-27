FROM ubuntu:latest

USER root

RUN apt-get update && \
    apt-get install -y \
      'curl' \
      'unzip' \
      'libxmu6'

COPY Fmask_4_0.install .
RUN chmod +x Fmask_4_0.install && \
    ./Fmask_4_0.install -mode silent -agreeToLicense yes && \
    rm Fmask_4_0.install

COPY run_fmask.sh /usr/local/bin/run_fmask.sh
RUN chmod +x /usr/local/bin/run_fmask.sh

VOLUME ["/mnt/input-dir"]
VOLUME ["/mnt/output-dir"]

WORKDIR /work

ENTRYPOINT ["/usr/local/bin/run_fmask.sh"]