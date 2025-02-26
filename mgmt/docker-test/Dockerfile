FROM debian:12.9

ENV container docker

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    dbus openssh-server sudo systemd systemd-sysv \
    ca-certificates gnupg python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a systemd service directory
RUN mkdir -p /etc/systemd/system

# Mask getty services to avoid issues with container TTY
RUN systemctl mask getty@.service && \
    systemctl mask getty.target && \
    systemctl mask dev-hugepages.mount && \
    systemctl mask sys-fs-fuse-connections.mount && \
    systemctl mask sys-kernel-config.mount && \
    systemctl mask sys-kernel-debug.mount && \
    systemctl mask sys-kernel-tracing.mount

# Set default target to multi-user
RUN systemctl set-default multi-user.target

# Create a default user and enable sudo
RUN useradd -m -s /bin/bash ansible && \
    echo 'ansible:password' | chpasswd && \
    echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Allow root login via SSH
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'root:password' | chpasswd

# Install tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            curl iputils-ping logrotate vim wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Enable and start SSH service
RUN systemctl enable ssh

# Expose systemd journal
VOLUME ["/sys/fs/cgroup", "/run", "/tmp"]

STOPSIGNAL SIGRTMIN+3

ENTRYPOINT ["/lib/systemd/systemd"]
