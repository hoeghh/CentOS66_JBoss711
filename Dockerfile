FROM centos:6.6
MAINTAINER Henrik Rene Hoegh <heh@praqma.net>

# Execute system update
RUN yum -y update && yum clean all

# Install packages necessary to run EAP
RUN yum -y install pwgen wget xmlstarlet saxon augeas bsdtar unzip && yum clean all

# Create a user and group used to launch processes
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
# so there is a high chance that this ID will be equal to the current user
# making it easier to use volumes (no permission issues)
RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss


# Set the working directory to jboss' user home directory
WORKDIR /opt/jboss

# Install Java JDKi 1.7.0
RUN yum -y install java-1.7.0-openjdk-devel && yum clean all

#Setting JAVA_HOME and JBOSS_HOME
ENV JAVA_HOME /usr/lib/jvm/java
ENV JBOSS_HOME /opt/jboss/jboss-as-7.1.1.Final

#Get JBoss 7.1.1 from Jboss.org and unzip it
RUN wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip && unzip jboss-as-7.1.1.Final.zip && rm -f jboss-as-7.1.1.Final.zip

RUN sed -i -r 's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:0.0.0.0/' /opt/jboss/jboss-as-7.1.1.Final/standalone/configuration/standalone.xml

ADD mgmt-users.properties /opt/jboss/jboss-as-7.1.1.Final/standalone/configuration/mgmt-users.properties
ADD mgmt-users.properties /opt/jboss/jboss-as-7.1.1.Final/domain/configuration/mgmt-users.properties

# Expose the ports we're interested in, 8080 for webinterface and 9990 for Admin Console.
EXPOSE 8080 9990 

# Set the default command to run on boot
# # This will boot JBoss in the standalone mode and bind to all interface
CMD ["/opt/jboss/jboss-as-7.1.1.Final/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement 0.0.0.0"]
