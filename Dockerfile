FROM jboss/wildfly
ADD target/ROOT.war /opt/jboss/wildfly/standalone/deployments/
EXPOSE 8080 9990
