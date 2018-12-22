FROM ubuntu:latest


# --- configuration section ----------------------
ENV DOCKERIMAGE_INSTALLATIONSCHEME scheme-full


# --- dependencies / installation section --------
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install golang-go git curl wget perl gnupg
RUN apt-get autoremove -y
RUN go get -u github.com/tcnksm/ghr

RUN mkdir -p /tmp/tex && curl -L http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz --strip 1 -C /tmp/tex;

RUN echo "selected_scheme $DOCKERIMAGE_INSTALLATIONSCHEME\nTEXDIR /usr/local/texlive/\nTEXMFCONFIG ~/.texlive/texmf-config\nTEXMFHOME ~/texmf\nTEXMFLOCAL /usr/local/texlive/texmf-local\nTEXMFSYSCONFIG /usr/local/texlive/texmf-config\nTEXMFSYSVAR /usr/local/texlive/texmf-var\nTEXMFVAR ~/.texlive/texmf-var\nbinary_x86_64-linux 1\ncollection-basic 1\ncollection-bibtexextra 1\ncollection-binextra 1\ncollection-context 1\ncollection-fontsextra 1\ncollection-fontsrecommended 1\ncollection-fontutils 1\ncollection-formatsextra 1\ncollection-games 1\ncollection-humanities 1\ncollection-langarabic 1\ncollection-langchinese 1\ncollection-langcjk 1\ncollection-langcyrillic 1\ncollection-langczechslovak 1\ncollection-langenglish 1\ncollection-langeuropean 1\ncollection-langfrench 1\ncollection-langgerman 1\ncollection-langgreek 1\ncollection-langitalian 1\ncollection-langjapanese 1\ncollection-langkorean 1\ncollection-langother 1\ncollection-langpolish 1\ncollection-langportuguese 1\ncollection-langspanish 1\ncollection-latex 1\ncollection-latexextra 1\ncollection-latexrecommended 1\ncollection-luatex 1\ncollection-mathscience 1\ncollection-metapost 1\ncollection-music 1\ncollection-pictures 1\ncollection-plaingeneric 1\ncollection-pstricks 1\ncollection-publishers 1\ncollection-texworks 1\ncollection-xetex 1\ninstopt_adjustpath 0\ninstopt_adjustrepo 1\ninstopt_letter 0\ninstopt_portable 0\ninstopt_write18_restricted 1\ntlpdbopt_autobackup 0\ntlpdbopt_backupdir tlpkg/backups\ntlpdbopt_create_formats 1\ntlpdbopt_desktop_integration 0tlpdbopt_file_assocs 1\ntlpdbopt_generate_updmap 0\ntlpdbopt_install_docfiles 1\ntlpdbopt_install_srcfiles 1\ntlpdbopt_post_code 1\ntlpdbopt_sys_bin /usr/local/bin\ntlpdbopt_sys_info /usr/local/share/info\ntlpdbopt_sys_man /usr/local/share/man\ntlpdbopt_w32_multi_user 1\n" > /tmp/texinstall.profile
RUN /tmp/tex/install-tl -profile /tmp/texinstall.profile
RUN echo "\$pdf_mode  = 1;\n\$bibtex_use = 2;\n\$pdflatex  = 'pdflatex -halt-on-error -file-line-error -shell-escape -interaction=nonstopmode -synctex=1 %O %S';\n\$clean_ext = 'synctex.gz synctex.gz(busy) run.xml xmpi acn acr alg glsdefs vrb bbl ist glg glo gls ist lol log 1 dpth auxlock %R-figure*.* %R-blx.bib snm nav dvi xmpi tdo';\n\nadd_cus_dep('glo', 'gls', 0, 'makeglossaries');\nadd_cus_dep('acn', 'acr', 0, 'makeglossaries');\nadd_cus_dep('mp', '1', 0, 'mpost');\n\nsub makeglossaries {\nreturn system('makeglossaries', \$_[0]);\n}\n\nsub mpost {\nmy (\$name, \$path) = fileparse( \$_[0] );\nmy \$return = system('mpost', \$_[0]);\nif ( (\$path ne '') && (\$path ne '.\\\\\\\\') && (\$path ne './') ) {\nforeach ( '\$name.1', '\$name.log' ) { move \$_, \$path; }\n}\nreturn \$return;\n}\n" > /root/.latexmkrc


# --- machine configuration section --------------
ENV TEXMFHOME /root/texmf
ENV PATH /usr/local/texlive/bin/x86_64-linux:/root/go/bin:$PATH
RUN tlmgr update --self --all --reinstall-forcibly-removed
