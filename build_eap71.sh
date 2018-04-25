#!/bin/bash

mvn -Dwildfly.groupId=jboss-eap -Dwildfly.artifactId=jboss-eap-dist -Dversion.wildfly=7.1.0.GA -Dwildfly.directory=jboss-eap-7.1 clean install
