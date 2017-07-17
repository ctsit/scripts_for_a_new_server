#This script requires two arguments:
#$1 is the directory of this project
#$2 is the hostname of this server

script_dir=$1
hostname=$2

#strings to replace in the Open Systems xml
hostname_replace=_HOSTNAME_
urn_replace=_URN_

echo Type the shib urn for this server, followed by enter:
read shib_urn

#install shibboleth packages
apt-get -y install shibboleth-sp2-schemas libshibsp-dev
apt-get -y install libshibsp-doc libapache2-mod-shib2 opensaml2-tools

#generate key/cert for shib and place it in proper directory
cd /etc/shibboleth
/usr/sbin/shib-keygen -o . -h $hostname
mv sp-key.pem $hostname.key
mv sp-cert.pem $hostname.cert

#Get Linux XML config file from Open Systems and configure it
mv shibboleth2.xml shibboleth2_`date +'%s'`.xml.bak
wget http://open-systems.ufl.edu/files/linux.shibboleth2.xml -O shibboleth2.xml

sed -i "s/$hostname_replace/$hostname/g" shibboleth2.xml
sed -i "s/$urn_replace/$shib_urn/g" shibboleth2.xml
sed -i "s:/var/lib/run/shibd.sock:/var/run/shibboleth/shibd.sock:" shibboleth2.xml

#Update Apache to use shibboleth
cd /etc/apache2/
cp apache2.conf apache2_`date +'%s'`.conf.bak
echo >> apache2.conf
echo ******Created Using Little Grebe Server Setup*****
echo \# Include Shibboleth >> apache2.conf
echo LoadModule mod_shib /usr/lib/apache2/modules/mod_shib2.so >> apache2.conf

cd sites-enabled
cp default-ssl.conf default-ssl_`date +'%s'`.conf.bak
sed -i "/DocumentRoot/r $script_dir/utils/shib_apache_setup.txt" default-ssl.conf

#Restart and test
echo Finished configuring, restarting services
cd $script_dir/output
service apache2 restart
service shibd restart
wget --no-check-certificate https://$hostname/Shibboleth.sso/Metadata
