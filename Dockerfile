ARG TAC_PLUS_VERSION=F4.0.4.28

FROM alpine:3.9
ARG TAC_PLUS_VERSION

RUN apk add --no-cache gcc make musl-dev libnsl-dev flex bison perl

WORKDIR /tmp
RUN wget ftp://anonymous:foo\@bar.com@ftp.shrubbery.net/pub/tac_plus/tacacs-${TAC_PLUS_VERSION}.tar.gz && \
    tar zxf tacacs-${TAC_PLUS_VERSION}.tar.gz && \
    cd tacacs-${TAC_PLUS_VERSION} && \
    ./configure --without-libwrap && \
    make && \
    make install

# cleanup
RUN rm -rf /tmp/tacacs-${TAC_PLUS_VERSION}.tar.gz /tmp/tacacs-${TAC_PLUS_VERSION}/
RUN apk del --purge gcc make musl-dev libnsl-dev flex bison perl

FROM alpine:3.9
ARG TAC_PLUS_VERSION

LABEL MAINTAINER Minsuk Song <msuk.song@gmail.com>
LABEL tac_plus.version ${TAC_PLUS_VERSION}

COPY --from=0 /usr/local/lib /usr/local/lib
COPY --from=0 /usr/local/sbin/tac_plus /usr/local/sbin/tac_plus
COPY files/tac_plus.conf /etc/tac_plus.conf

ENV TACPLUS_CONF /etc/tac_plus.conf
ENV DEBUGLEVEL 24

EXPOSE 49
CMD /usr/local/sbin/tac_plus -G -d ${DEBUGLEVEL} -C ${TACPLUS_CONF} -l /dev/stdout
