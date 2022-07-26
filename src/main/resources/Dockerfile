FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:latest

EXPOSE 8080

LABEL description="Windup Migration Toolkit for Applications Web Console" \
      version="4.0.0-SNAPSHOT" \
      io.k8s.description="Windup Migration Toolkit for Applications Web Console" \
      io.k8s.display-name="WINDUP Web Console" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="windup,migration"

ADD . /opt/windup-web-distribution/
#RUN chown --recursive jboss:jboss /opt/windup-web-distribution

user 0
RUN chown --recursive jboss:0 /opt/windup-web-distribution
RUN chgrp -R 0 /opt/windup-web-distribution \
  && chgrp -R 0 /home/jboss \
  && chmod -R g+rwX /opt/windup-web-distribution \
  && chmod -R g+rwX /home/jboss

user jboss

ENTRYPOINT /opt/windup-web-distribution/run_windup.sh -b 0.0.0.0


