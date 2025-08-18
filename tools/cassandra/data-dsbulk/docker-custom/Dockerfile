# Apache License 2.0 https://github.com/datastax/dsbulk/blob/1.x/LICENSE.txt
# forked from on https://github.com/TrivadisPF/dockerfiles/blob/master/dse-dsbulk/Dockerfile
FROM openjdk:8u312-jdk-slim-bullseye

ARG VERSION=1.8.0
ARG URL_PREFIX=https://github.com/datastax/dsbulk/releases/download
ARG DSBULK_TARBALL=dsbulk-${VERSION}.tar.gz
ARG DSBULK_DOWNLOAD_URL=${URL_PREFIX}/${VERSION}/${DSBULK_TARBALL}

RUN apt-get update && apt-get install \
    bash-completion \
    htop curl wget net-tools iputils-ping traceroute \
    python s3cmd mc\
    sysstat locales -y --no-install-recommends && \
	apt-get autoclean && apt-get --purge -y autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen

ENV DSBULK_HOME /dsbulk

RUN set -x \
    && groupadd -r dsbulk --gid=999 \
    && useradd -m -d "$DSBULK_HOME" -r -g dsbulk --uid=999 dsbulk

COPY --chown=dsbulk:dsbulk htoprc /dsbulk/.config/htop/

RUN set -x \
    && mkdir /dsbulk/.config/mc \
    && mkdir /dsbulk/.cache \
    && mkdir /dsbulk/.cache/mc \
    && mkdir /dsbulk/.local \
    && mkdir /dsbulk/.local/share \
    && mkdir /dsbulk/.local/share/mc \
    && chown -R dsbulk:dsbulk /dsbulk

ADD ${DSBULK_DOWNLOAD_URL} /${DSBULK_TARBALL}

RUN set -x \
    && tar -C "$DSBULK_HOME" --strip-components=1 -xzf /${DSBULK_TARBALL} \
    && rm /${DSBULK_TARBALL} \
    && mkdir -p $DSBULK_HOME/logs $DSBULK_HOME/data \
    && chown -R dsbulk:dsbulk ${DSBULK_HOME}

ENV PATH $DSBULK_HOME/bin:$PATH
ENV HOME $DSBULK_HOME
WORKDIR $HOME

SHELL ["/bin/bash", "-c"]

USER dsbulk

# Run
ENTRYPOINT [ "/dsbulk/bin/dsbulk" ]