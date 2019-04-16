FROM jboss/wildfly
 
ADD target/ROOT.war /opt/jboss/wildfly/standalone/deployments/
