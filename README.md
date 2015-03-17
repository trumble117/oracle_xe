# Oracle Express Edition 11gR2 for Docker
Description: Docker automated build for Oracle XE container

NOTICE: This build image contains proprietary (closed-source) software!

By using the scripts contained in this repository, you agree to the terms set forth in the Oracle OTN license agreement. The agreement, in it's entirety, can be found here: http://www.oracle.com/technetwork/licenses/database-11g-express-license-459621.html
This image is provided for development use only, and shall not be used in a production system of any kind.
I, the developer, do not represent Oracle by providing these scripts or software.

This software, along with the aforementioned scripts are provided without warranty or support, either express or implied from either myself, or Oracle.

INSTRUCTIONS:

1) Edit Dockerfile and uncomment the line to run pre.sh. Docker's build images don't have sufficient RAM to pass the check, so it was commented out for build purposes. For actual use, you'll want the prerequisite checks to run

2) Run the docker build:

   docker build -t oracle_xe .

3) Run the container after a successful build:
   
   docker run -p 1521:1521 -p 8080:8080 -d oracle_xe
