FROM opensuse/leap

RUN zypper ref && zypper in -y osc cat

COPY entrypoint.sh /entrypoint.sh
COPY build.sh /build.sh

ENTRYPOINT ["/entrypoint.sh"]
