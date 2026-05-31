#!/bin/bash

# 1. Update system package repositories and dependencies
dnf update -y
dnf install java-21-amazon-corretto -y
dnf install wget tar awscli mariadb105 -y

# 2. Set explicitly required Java Environment Variables for Tomcat execution
export JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto
export PATH=$JAVA_HOME/bin:$PATH

# 3. Pull and extract Tomcat 11 to the /opt directory
cd /opt
wget https://archive.apache.org/dist/tomcat/tomcat-11/v11.0.4/bin/apache-tomcat-11.0.4.tar.gz
tar -xzf apache-tomcat-11.0.4.tar.gz
mv apache-tomcat-11.0.4 tomcat

# 4. Resolve permissions and prepare the webapps directory
chmod +x /opt/tomcat/bin/*.sh
rm -rf /opt/tomcat/webapps/ROOT

# 5. Fetch application code from S3 using IAM Instance Profile authorization
aws s3 cp s3://project5warfile/ROOT.war /opt/tomcat/webapps/ROOT.war

# 6. Wait for RDS endpoint provisioning availability
sleep 90

# 7. Connect using template variables passed dynamically from Terraform
mysql -h ${rds_endpoint} -u ${db_user} -p'${db_pass}' <<EOF
CREATE DATABASE IF NOT EXISTS studentdb;

USE studentdb;

CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    course VARCHAR(100)
);
EOF

# 8. Start Tomcat server
/opt/tomcat/bin/startup.sh
