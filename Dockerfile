FROM ubuntu:latest


# --- dependencies base installation --------
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install golang-go git curl wget perl gnupg
RUN apt-get autoremove -y
RUN go get -u github.com/tcnksm/ghr
