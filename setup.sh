#Script should be as root
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be run using sudo or as the root user"
    exit 1
fi
#Change to the directory where the script is located
cd "$(dirname "$0")"

echo *******NETWORKING********
bash network/setup.sh

echo *******APT-GET UPDATE*******
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cat utils/sources.list>>/etc/apt/sources.list
apt-get -y update
apt-get -y upgrade

echo *******KERBEROS*******
bash kerberos/setup.sh
bash kerberos/add_authenticated_user.sh

echo *******OPENSSH*******
apt-get -y install openssh-server

shutdown -r +1 "Server will restart in 1 minute. Please save your work."
echo To cancel, type 'shutdown -c'
