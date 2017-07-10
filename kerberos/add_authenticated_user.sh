echo enter gatorlink you want to add and press ENTER
read NEWUSER

sudo -E useradd -g users -m -s /bin/bash -d /home/$NEWUSER $NEWUSER
sudo -E usermod -a -G sudo $NEWUSER
echo Testing if kerberos is working,
echo there should be a valid token after logging in:
kinit -p $NEWUSER@AD.UFL.EDU
klist
