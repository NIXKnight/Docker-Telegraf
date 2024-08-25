FROM telegraf:1.31.3

ARG DEBIAN_FRONTEND noninteractive

ENV VIRTUAL_ENV="/opt/deye-controller"
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

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
  apt-get install -y --no-install-recommends iputils-ping zfsutils-linux smartmontools nvme-cli socat jq python-is-python3 python3-pip python3-venv; \
  apt-get clean all; \
  rm -r /var/lib/apt/lists /var/cache/apt/archives; \
  mkdir -p /usr/local/run/telegraf_unix_sockets; \
  chown -R telegraf:telegraf /usr/local/run/telegraf_unix_sockets

RUN set -eux; \
    python -m venv "${VIRTUAL_ENV}"; \
    pip install deye-controller
