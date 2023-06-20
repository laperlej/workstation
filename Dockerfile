FROM ubuntu:kinetic AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential sudo && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible stow && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS laperlej
ARG TAGS
RUN addgroup --gid 1000 laperlej && \
    adduser --gecos laperlej --uid 1000 --gid 1000 --disabled-password laperlej && \
    usermod -aG sudo laperlej
USER laperlej
WORKDIR /home/laperlej

FROM laperlej
USER root
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
COPY --chown=laperlej:laperlej . .
USER laperlej
ENV USER=laperlej
CMD ["sh", "-c", "ansible-playbook --tags ssh,dotfiles,install -v local.yml"]
