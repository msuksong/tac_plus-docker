FROM alpine:3.9
LABEL maintainer="Minsuk Song <msuk.song@gmail.com>"

RUN wget ftp://anonymous:foo\@bar.com@ftp.shrubbery.net/pub/tac_plus/tacacs-F4.0.4.28.tar.gz && \
    tar zxf tacacs-F4.0.4.28.tar.gz && \
    apk add --no-cache gcc make musl-dev libnsl-dev flex bison perl && \
    cd tacacs-F4.0.4.28 && \ 
    ./configure --without-libwrap && \
    make && \
    make install && \
    cd ..  && \
    rm -rf tacacs-F4.0.4.28.tar.gz tacacs-F4.0.4.28/ && apk del --purge gcc make musl-dev libnsl-dev flex bison perl

COPY files/tac_plus.conf /etc/tac_plus.conf

ENV TACPLUS_CONF /etc/tac_plus.conf
ENV DEBUGLEVEL 24

EXPOSE 49
CMD /usr/local/sbin/tac_plus -G -d ${DEBUGLEVEL} -C ${TACPLUS_CONF} -l /dev/stdout
