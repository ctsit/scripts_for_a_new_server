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
mkdir output
echo Script started `date` >> output/output.log

echo type the domain for this server - yourdomain.ufl.edu, followed by <ENTER>
read hostname

echo *******NETWORKING********
bash network/setup.sh $working_dir
echo Networking has been set up >> output/output.log

echo *******APT-GET UPDATE*******
cp /etc/apt/sources.list /etc/apt/sources_`date +'%s'`.list.bak
cat utils/sources.list>>/etc/apt/sources.list
echo apt sources list has been updated >> output/output.log
apt-get -y update
apt-get -y upgrade
apt-get -y install sudo
echo sudo has been installed >> output/output.log

echo *******KERBEROS*******
bash kerberos/setup.sh $working_dir
echo kerberos has been set up >> output/output.log
bash kerberos/add_authenticated_user.sh
echo new user added to kerberos >> output/output.log

echo *******OPENSSH*******
apt-get -y install openssh-server
echo openssh-server installed >> output/output.log

echo *******SHIBBOLETH******
bash utils/apache_setup.sh $working_dir $host_name
echo Apache2 setup and installed >> output/output.log
bash utils/shib_setup.sh $working_dir $host_name
echo shibboleth setup and installed >> output/output.log

echo Script completed `date` >> output/outout.log
shutdown -r +1 "Server will restart in 1 minute. Please save your work."
echo To cancel, type 'shutdown -c'

exit 0
