# Use the OEL6 base image
FROM jwalkertrumble/oel6:6.6 

# Maintainer of the image
MAINTAINER Johnathon Trumble

# Copy the RPM file, modified init.ora, initXETemp.ora and the installation response file
# inside the image
ADD source/ /tmp/

# Extract the zip
RUN unzip /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm.zip -d /tmp

# Run necessary prerequisite checks for XE, since we have to skip them during RPM install
RUN /tmp/pre.sh

# Install the Oracle XE RPM
RUN rpm -ivh --nopre /tmp/Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm

# Move the files init.ora and initXETemp.ora to the right directory
RUN mv /tmp/init.ora /u01/app/oracle/product/11.2.0/xe/config/scripts
RUN mv /tmp/initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts

# Configure the database
RUN /etc/init.d/oracle-xe configure responseFile=/tmp/xe.rsp

# Cleanup temp
RUN rm -rf /tmp/Disk1 /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm.zip /tmp/xe.rsp

# Copy run script to container
ADD xe.run /xe.run

# Expose ports 1521 and 8080
EXPOSE 1521
EXPOSE 8080

# Change the hostname in the listener.ora file, start Oracle XE and the ssh daemon
CMD /xe.run
