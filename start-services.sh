#!/bin/bash

# 1. Start MySQL Service
echo "Starting MySQL service..."
service mysql start
sleep 5 # Give MySQL a few seconds to start

# 2. Guideline 1h: Create one user in MySQL.
# We will create a user named 'myuser' with password 'mypassword'
echo "Creating MySQL user 'myuser'..."
mysql -e "CREATE USER 'myuser'@'localhost' IDENTIFIED BY 'mypassword';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'myuser'@'localhost' WITH GRANT OPTION;"
mysql -e "FLUSH PRIVILEGES;"
echo "MySQL user created. (User: myuser, Pass: mypassword)"

# 3. Start Tomcat Service (Guideline 1c)
echo "Starting Tomcat service..."
service tomcat9 start

# 4. Start VNC Server for GUI (Guideline 1d)
# We need to set a password for the VNC connection.
# The password will be: vncpass
echo "Setting up VNC server..."
mkdir -p /root/.vnc
echo "vncpass" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Start the VNC server on display :1
echo "Starting VNC server on :1"
vncserver :1 -geometry 1280x800 -depth 24 -localhost no

echo "-----------------------------------------------------"
echo "  Container is READY!"
echo "  VNC Password: vncpass"
echo "  MySQL User:   myuser"
echo "  MySQL Pass:   mypassword"
echo "-----------------------------------------------------"

# 5. Keep the container running
# This command will run forever so the container doesn't stop.
tail -f /dev/null