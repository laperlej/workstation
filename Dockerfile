FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential stow && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS laperlej
ARG TAGS
RUN addgroup --gid 1000 laperlej
RUN adduser --gecos laperlej --uid 1000 --gid 1000 --disabled-password laperlej
USER laperlej
WORKDIR /home/laperlej

FROM laperlej
COPY --chown=laperlej:laperlej . .
ENV USER=laperlej
CMD ["sh", "-c", "ansible-playbook --tags ssh,dotfiles -v local.yml --ask-vault-pass"]
