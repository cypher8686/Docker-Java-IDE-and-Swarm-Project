# -----------------------------------------------------------------
# Guideline 1a: Use base OS as Ubuntu.
# -----------------------------------------------------------------
FROM ubuntu:22.04

# -----------------------------------------------------------------
# Set a non-interactive "frontend" to prevent apt-get from
# trying to open pop-up windows during the build.
# This is crucial for installing software in a Dockerfile.
# -----------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive

# -----------------------------------------------------------------
# Update Ubuntu's package lists and install essential tools
# (like 'wget' to download files and 'nano' for text editing)
# -----------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y wget nano dos2unix

# -----------------------------------------------------------------
# Guideline 1b: Install and configure openJDK.
# We will install openJDK 17.
# -----------------------------------------------------------------
RUN apt-get install -y openjdk-17-jdk

# -----------------------------------------------------------------
# Guideline 1b (cont.): Set environment variables.
# We set JAVA_HOME to tell the system where Java is installed.
# -----------------------------------------------------------------
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# -----------------------------------------------------------------
# Guideline 1c: Install and configure Apache Tomcat.
# We will install Tomcat 9.
# -----------------------------------------------------------------
RUN apt-get install -y tomcat9

# -----------------------------------------------------------------
# Guideline 1h: Install and configure MySQL.
# We will install the MySQL Server.
# -----------------------------------------------------------------
RUN apt-get install -y mysql-server

# -----------------------------------------------------------------
# Guideline 1j: Expose necessary ports.
# 8080 is the default port for Tomcat (Guideline 1c)
# 3306 is the default port for MySQL (Guideline 1h)
# -----------------------------------------------------------------
EXPOSE 8080
EXPOSE 3306

# -----------------------------------------------------------------
# Guideline 1k: Specify a working directory to start.
# -----------------------------------------------------------------
WORKDIR /app


# -----------------------------------------------------------------
# Guideline 1d: Configure Ubuntu for a GUI based IDE.
# We will install a lightweight XFCE desktop and a VNC server
# to access the GUI. We also install required libraries for Eclipse.
# -----------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y xfce4 xfce4-goodies \
    tigervnc-standalone-server tigervnc-common \
    dbus-x11 \
    libgtk-3-0 libwebkit2gtk-4.0-37 && \
    apt-get clean

# -----------------------------------------------------------------
# Guidelines 1e, 1f, 1g: Install/configure Spring, Boot, Cloud
# The standard way to "install" these is to install Maven,
# which manages these libraries (dependencies) for any Java project.
# -----------------------------------------------------------------
RUN apt-get install -y maven

# -----------------------------------------------------------------
# Guideline 1d (cont.): Install Eclipse IDE.
# We download the Eclipse IDE for Java Developers,
# unpack it, and move it to the /opt directory.
# We use a known-good link for the 2023-09 version.
# -----------------------------------------------------------------
RUN wget https://download.eclipse.org/technology/epp/downloads/release/2023-09/R/eclipse-jee-2023-09-R-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz && \
    mkdir -p /opt/eclipse && \
    tar -xvzf /tmp/eclipse.tar.gz -C /opt/eclipse --strip-components=1 && \
    rm /tmp/eclipse.tar.gz

# -----------------------------------------------------------------
# Guideline 1d (cont.): Expose VNC port
# This allows us to connect to the container's GUI.
# Default VNC port is 5901 (for display :1)
# -----------------------------------------------------------------
EXPOSE 5901


# -----------------------------------------------------------------
# Final Step: Copy and run our startup script.
# This script will start MySQL, Tomcat, and VNC.
# -----------------------------------------------------------------
COPY start-services.sh /app/start-services.sh
RUN dos2unix /app/start-services.sh
RUN chmod +x /app/start-services.sh
CMD ["/app/start-services.sh"]