FROM opensuse/tumbleweed

RUN zypper ref && zypper in -y -f osc

COPY entrypoint.sh /entrypoint.sh
COPY build.sh /build.sh

ENTRYPOINT ["/entrypoint.sh"]
