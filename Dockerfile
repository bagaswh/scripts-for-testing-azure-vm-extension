FROM ubuntu

WORKDIR /data

COPY . /data

ENTRYPOINT ["./start.sh"]