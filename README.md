# little_grebe_server_setup
This project contains a set of scripts used by the CTS-IT team at the 
University of Florida. It allows a server with a barebones Debian install
to get up and going using Kerberos and SSH (with gatorlink authentication).

# Installation instructions
To get going, there is a setup.sh script in the parent directory.
This script requires root privileges in order to do installs and 
overwrites of protected files. 

The installation does the following in order:
1: Sets up the network by copying a default 'interfaces' file over to the 
   network directory, then restarts the network service.
2: Updates the source list for apt, updates and upgrades. Installs Sudo.
3: Installs kerberos and adds a default user. 
4: Installs openssh-server for ssh capabilities
5: Installs Shibboleth

Some things in the setup may want to be ignored, such as changing the
networking settings. To do this, just comment out the line of the 
section that is not needed.
