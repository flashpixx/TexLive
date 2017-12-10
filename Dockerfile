FROM alpine:3.7

# --- configuration section ----------------------
ENV GLIBC_VERSION 2.26-r0
ENV INSTALLATION full



# --- dependencies section -----------------------
RUN wget -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub
RUN wget -O /tmp/glibc.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk
RUN wget -O /tmp/glibc-bin.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-bin-$GLIBC_VERSION.apk
RUN wget -O /tmp/glibc-i18n.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-i18n-$GLIBC_VERSION.apk

RUN apk --no-cache update &&\
    apk --no-cache upgrade &&\
    apk --no-cache add ca-certificates /tmp/glibc.apk /tmp/glibc-bin.apk /tmp/glibc-i18n.apk musl-dev curl wget git openssh-client gnupg perl go

RUN /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8
RUN go get -u github.com/tcnksm/ghr

RUN mkdir -p /tmp/tex && curl -L http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz --strip 1 -C /tmp/tex;
ENV INSTALLATIONCONFIG selected_scheme scheme-$INSTALLATION\\nTEXDIR /usr/local/texlive/\\nTEXMFLOCAL /usr/local/texlive/texmf-local\\nTEXMFSYSCONFIG /usr/local/texlive/texmf-config\\nTEXMFSYSVAR /usr/local/texlive/texmf-var\\nTEXMFHOME /root/texmf\nTEXMFCONFIG /root/.texlive/texmf-config\\nTEXMFVAR /root/.texlive/texmf-var\\nbinary_x86_64-linux 1\\ninstopt_adjustpath 1\\ninstopt_adjustrepo 1\\ninstopt_letter 1\\ninstopt_portable 0\\ninstopt_write18_restricted 1\\ntlpdbopt_autobackup 1\\ntlpdbopt_backupdir tlpkg/backups\\ntlpdbopt_create_formats 1\\ntlpdbopt_desktop_integration 0\\ntlpdbopt_file_assocs 1\\ntlpdbopt_generate_updmap 0\\ntlpdbopt_install_docfiles 0\\ntlpdbopt_install_srcfiles 0\\ntlpdbopt_post_code 1\\ntlpdbopt_sys_bin /tmp\\ntlpdbopt_sys_info /tmp\\ntlpdbopt_sys_man /tmp\\ntlpdbopt_w32_multi_user 1\\n
RUN echo -e "$INSTALLATIONCONFIG" > /tmp/texinstall.profile; /tmp/tex/install-tl -profile /tmp/texinstall.profile;

ENV TEXMFHOME /root/texmf
ENV PATH /usr/local/texlive/bin/x86_64-linux:/root/go/bin:$PATH
RUN tlmgr update --self --all --reinstall-forcibly-removed

RUN rm -rf /tmp/*
