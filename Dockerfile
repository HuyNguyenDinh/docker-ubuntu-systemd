FROM ubuntu:jammy

LABEL maintainer="Huy Nguyen Dinh <huyn27316@gmail.com>"
LABEL build_date="2023-11-01"

ENV container docker
ENV TZ=UTC
    
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Enable apt repositories.
RUN sed -i 's/# deb/deb/g' /etc/apt/sources.list

# Enable systemd.
RUN apt-get update ; \
    apt-get install -y systemd systemd-sysv ; \
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

RUN apt-get update && apt-get install -y openssh-server sudo dbus

# Create a new user named 'ubuntu' and add SSH setup
RUN useradd -m -s /bin/bash ubuntu && \
    mkdir -p /home/ubuntu/.ssh && \
    chmod 700 /home/ubuntu/.ssh

RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu
COPY --chown=ubuntu:ubuntu .ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys

RUN chmod 600 /home/ubuntu/.ssh/authorized_keys && \
    chown ubuntu:ubuntu -R /home/ubuntu/.ssh

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

RUN systemctl enable ssh

CMD ["/lib/systemd/systemd"]
