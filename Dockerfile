FROM ubuntu:noble

LABEL maintainer="Huy Nguyen Dinh <huyn27316@gmail.com>"
LABEL build_date="2024-11-01"

ENV container docker
ENV TZ="UTC"

# Enable apt repositories.
RUN sed -i 's/# deb/deb/g' /etc/apt/sources.list

# Enable systemd.
RUN apt-get update ; \
    apt-get install -y systemd systemd-sysv tzdata; \
    apt-get clean ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ; \
    cd /lib/systemd/system/sysinit.target.wants/ ; \
    ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 ; \
    rm -f /lib/systemd/system/multi-user.target.wants/* ; \
    rm -f /etc/systemd/system/*.wants/* ; \
    rm -f /lib/systemd/system/local-fs.target.wants/* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* ; \
    rm -f /lib/systemd/system/basic.target.wants/* ; \
    rm -f /lib/systemd/system/anaconda.target.wants/* ; \
    rm -f /lib/systemd/system/plymouth* ; \
    rm -f /lib/systemd/system/systemd-update-utmp*

RUN apt-get update && apt-get install software-properties-common -y # buildkit
RUN add-apt-repository ppa:deadsnakes/ppa # buildkit
RUN apt-get update && apt-get install -y build-essential python3.10 python3.10-venv python3.10-dev default-libmysqlclient-dev pkg-config gcc git vim # buildkit

# Set timezone
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime

CMD ["/lib/systemd/systemd"]
