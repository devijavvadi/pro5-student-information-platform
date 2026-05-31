#!/bin/bash

# Update OS

dnf update -y

# Install Java 21

dnf install java-21-amazon-corretto -y

# Install utilities + MySQL client

dnf install wget tar awscli mariadb105 -y

# Verify Java

java -version

# Move to /opt

cd /opt

# Download Tomcat 11

wget https://archive.apache.org/dist/tomcat/tomcat-11/v11.0.10/bin/apache-tomcat-11.0.10.tar.gz

# Extract Tomcat

tar -xzf apache-tomcat-11.0.10.tar.gz

# Rename directory

mv apache-tomcat-11.0.10 tomcat

# Permissions

chmod +x /opt/tomcat/bin/*.sh

# Remove default ROOT application

rm -rf /opt/tomcat/webapps/ROOT

# Download WAR from S3

aws s3 cp s3://project5warfile/ROOT.war /opt/tomcat/webapps/ROOT.war

# Wait for RDS to become available


until mysqladmin ping -h ${rds_endpoint} -u admin -p'Geethanshi1234' --silent
do
  echo "Waiting for RDS..."
  sleep 10
done

# Create database and table

mysql -h ${rds_endpoint} -u admin -p'Geethanshi1234' <<EOF
CREATE DATABASE IF NOT EXISTS studentdb;

USE studentdb;

CREATE TABLE IF NOT EXISTS students (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100),
email VARCHAR(100),
course VARCHAR(100)
);
EOF

# Start Tomcat

/opt/tomcat/bin/startup.sh
