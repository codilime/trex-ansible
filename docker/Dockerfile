FROM centos:7
MAINTAINER piotr.kowalczyk@codilime.com

ARG TREXVERSION="${TREXVERSION:-2.59}"

LABEL RUN docker run --privileged --network=host --cap-add=ALL \
  --name NAME \
  -v /mnt/huge:/mnt/huge \
  -v /lib/modules:/lib/modules:ro \
  -v /usr/src:/usr/src:ro \
  -v /sys/bus/pci/devices:/sys/bus/pci/devices \
  -v /sys/devices/system/node:/sys/devices/system/node \
  -v /dev:/dev

RUN yum upgrade -y && \
    yum install -y pciutils iproute net-tools vim strace && \
    yum group -y install "Development tools" ;\
    yum clean all && rm -rf /var/cache/yum

RUN mkdir /opt/trex-v${TREXVERSION} && ln -s /opt/trex-v${TREXVERSION} /opt/trex
COPY ./v${TREXVERSION}.tar.gz /tmp/
RUN tar xzf /tmp/v${TREXVERSION}.tar.gz -C /opt/trex --strip-components 1 && rm /tmp/v${TREXVERSION}.tar.gz && chown -R root: /opt/trex*

WORKDIR /opt/trex

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["/opt/trex/t-rex-64", "-i"]
