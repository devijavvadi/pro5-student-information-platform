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

# 6. Create a native Systemd Service File for Tomcat 11
# This stops cloud-init from killing Tomcat when the script finishes!
cat <<EOF | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
User=root
Group=root
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 7. Reload systemd and enable Tomcat to survive script exit
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

# 8. Wait 20 seconds to guarantee Tomcat completely unpacks ROOT.war
sleep 20

# 9. Inject your dynamic RDS endpoint into the newly extracted directory structure
cat <<EOF > /opt/tomcat/webapps/ROOT/WEB-INF/classes/application.properties
db.url=jdbc:mysql://${rds_endpoint}:3306/studentdb
db.username=${db_user}
db.password=${db_pass}
EOF

# 10. Wait for RDS endpoint provisioning availability
sleep 70

# 11. Connect to RDS to create the database and structural table
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

# 12. Restart Tomcat so your app reads the updated application.properties file
sudo systemctl restart tomcat
