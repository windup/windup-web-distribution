FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:latest

ADD . /opt/rhamt-web-distribution/
#RUN chown --recursive jboss:jboss /opt/rhamt-web-distribution

user 0
RUN chown --recursive jboss:0 /opt/rhamt-web-distribution
RUN chgrp -R 0 /opt/rhamt-web-distribution \
  && chmod -R g+rwX /opt/rhamt-web-distribution

user jboss

EXPOSE 8180:8180

ENTRYPOINT /opt/rhamt-web-distribution/run_rhamt.sh -b 0.0.0.0 -Djboss.socket.binding.port-offset=100


