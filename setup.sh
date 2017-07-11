#VERSION 1.0.0
#Script should be as root
if [[ $EUID -ne 0 ]]; then
    echo "This script should not be run using sudo or as the root user"
    exit 1
fi
#Change to the directory where the script is located
working_dir=$(cd `dirname $0` && pwd)
echo script is running from $working_dir
cd $working_dir 

echo *******NETWORKING********
bash network/setup.sh $working_dir

echo *******APT-GET UPDATE*******
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cat utils/sources.list>>/etc/apt/sources.list
apt-get -y update
apt-get -y upgrade
apt-get -y install sudo

echo *******KERBEROS*******
bash kerberos/setup.sh $working_dir
bash kerberos/add_authenticated_user.sh

echo *******OPENSSH*******
apt-get -y install openssh-server

shutdown -r +1 "Server will restart in 1 minute. Please save your work."
echo To cancel, type 'shutdown -c'

exit 0
