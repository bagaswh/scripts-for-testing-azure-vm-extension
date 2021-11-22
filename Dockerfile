FROM ubuntu
WORKDIR /data
ENV container docker
ENV PATH /snap/bin:$PATH
ADD snap /usr/local/bin/snap
RUN apt-get install -y wget snapd squashfuse fuse
RUN systemctl enable snapd
COPY . /data
ENTRYPOINT ["./start.sh"]