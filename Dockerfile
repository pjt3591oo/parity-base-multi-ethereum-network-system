FROM ubuntu:16.04

WORKDIR /home

RUN apt-get update
RUN apt-get install -y curl

COPY ./parity_installer.sh .

RUN chmod 777 parity_installer.sh
RUN ./parity_installer.sh

RUN rm ./parity_installer.sh

RUN mkdir blockchain
COPY ./parity_infos ./blockchain

WORKDIR /home/blockchain