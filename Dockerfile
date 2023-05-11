FROM golang:latest

ADD . /go/busboy
WORKDIR /go/busbuy
RUN cd /go/busboy && \
    make
EXPOSE 8580
