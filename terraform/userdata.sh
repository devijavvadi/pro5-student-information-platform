#!/bin/bash

# Update OS
dnf update -y

# Install Java 21
dnf install java-21-amazon-corretto -y

# Verify Java
java -version

# Install wget and tar
dnf install wget tar -y

# Move to /opt
cd /opt

# Download Tomcat 11
wget https://downloads.apache.org/tomcat/tomcat-11/v11.0.10/bin/apache-tomcat-11.0.10.tar.gz

# Extract Tomcat
tar -xzf apache-tomcat-11.0.10.tar.gz

# Rename directory
mv apache-tomcat-11.0.10 tomcat

# Permissions
chmod +x /opt/tomcat/bin/*.sh

# Start Tomcat
/opt/tomcat/bin/startup.sh