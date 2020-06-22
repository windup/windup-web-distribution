FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:latest

EXPOSE 8080

LABEL description="Migration Toolkit for Applications Web Console" \
      version="4.0.0-SNAPSHOT" \
      io.k8s.description="Migration Toolkit for Applications Web Console" \
      io.k8s.display-name="MTA Web Console" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="mta,migration"

ADD . /opt/mta-web-distribution/
#RUN chown --recursive jboss:jboss /opt/mta-web-distribution

user 0
RUN chown --recursive jboss:0 /opt/mta-web-distribution
RUN chgrp -R 0 /opt/mta-web-distribution \
  && chgrp -R 0 /home/jboss \
  && chmod -R g+rwX /opt/mta-web-distribution \
  && chmod -R g+rwX /home/jboss

user jboss

ENTRYPOINT /opt/mta-web-distribution/run_mta.sh -b 0.0.0.0


