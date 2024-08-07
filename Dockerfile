ARG ELIXIR_VERSION=1.17.2
ARG OTP_VERSION=27.0.1
ARG DEBIAN_VERSION=bookworm-20240722-slim
ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE}

# ARG NODE_VERSION=20.13.1

RUN apt-get update -y \
    && apt-get install -y \
        build-essential \
        git \
        curl \
        inotify-tools \
        bash-completion\
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

RUN echo "source /usr/share/bash-completion/completions/git" >> /root/.bashrc
    
# configure mix
RUN mix local.hex --force && mix local.rebar --force

# prepare build dir
WORKDIR /workspace