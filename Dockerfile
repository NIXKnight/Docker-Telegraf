FROM telegraf:1.39.1

ARG DEBIAN_FRONTEND noninteractive

ENV VIRTUAL_ENV="/opt/venv"
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

# This venv exists solely for the production poller script (get-deye-data.py) and
# pins its one direct dependency, pysolarmanv5, to 3.0.6. The script relies on the
# sync PySolarmanV5 API (eager socket connect in __init__; kwargs
# port/mb_slave_id/socket_timeout). pysolarmanv5 pulls umodbus (and pyserial via
# umodbus) itself, so no other pins are needed.
RUN set -eux; \
    python -m venv "${VIRTUAL_ENV}"; \
    pip install --no-cache-dir pysolarmanv5==3.0.6
