# TeX-Live Docker Container

![Docker](https://img.shields.io/docker/build/flashpixx/texlive.svg)

This container stores a complete installation of the LaTeX distribution with additional tools:

* The container based on a [Ubuntu Linux Latest](https://hub.docker.com/_/ubuntu)
* It contains the current [TeX-Live](https://www.tug.org/texlive/) LaTeX distribution
* [LaTeXMK](https://ctan.org/pkg/latexmk) configuration for building PDF with glossary and mpost
* A Git Client with OpenSSH support, Curl, Wget, Perl, GnuPG and Go are included
* The tool [GHR](http://deeeet.com/ghr/) is included to create GitHub release structure
