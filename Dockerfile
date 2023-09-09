FROM telegraf:1.27.4

ARG DEBIAN_FRONTEND noninteractive

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends lsb-release; \
  { \
    echo "deb http://deb.debian.org/debian/ $(lsb_release -cs) main contrib"; \
    echo "deb http://deb.debian.org/debian/ $(lsb_release -cs)-updates main contrib"; \
    echo "deb http://security.debian.org/ $(lsb_release -cs)-security main contrib"; \
  } | tee /etc/apt/sources.list; \
  apt-get update; \
  apt-get -y dist-upgrade; \
  apt-get install -y --no-install-recommends zfsutils-linux smartmontools nvme-cli; \
  apt-get clean all; \
  rm -r /var/lib/apt/lists /var/cache/apt/archives
