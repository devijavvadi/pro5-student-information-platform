#!/bin/bash

# Update OS
dnf update -y

# Install Java 21
dnf install java-21-amazon-corretto -y

# Install utilities
dnf install wget tar awscli -y

# Verify Java
java -version

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

# Create application config
mkdir -p /opt/studentapp

cat > /opt/studentapp/db.properties <<EOF
db.url=jdbc:mysql://${rds_endpoint}:3306/studentdb
db.username=studentadmin
db.password=StudentInfo2026!
EOF

# Download WAR from S3
aws s3 cp s3://project5warfile/ROOT.war /opt/tomcat/webapps/ROOT.war

# Start Tomcat
/opt/tomcat/bin/startup.sh