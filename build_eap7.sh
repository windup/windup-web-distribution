#!/bin/bash

mvn -Dwildfly.groupId=jboss-eap -Dwildfly.artifactId=jboss-eap-dist -Dversion.wildfly=7.0.0.GA -Dwildfly.directory=jboss-eap-7.0 clean install
