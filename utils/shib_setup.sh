#strings to replace in the Open Systems xml
hostname_replace=_HOSTNAME_
urn_replace=_URN_
shib_urn=urn:edu:ufl:prod:URN

echo Installing Shibboleth...
echo type the domain for this server - shib.yourdomain.ufl.edu, followed by enter
read hostname

#install shibboleth packages
apt-get -y install shibboleth-sp2-schemas libshibsp-dev
apt-get -y install libshibsp-doc libapache2-mod-shib2 opensaml2-tools

#generate key/cert for shib and place it in proper directory
cd /etc/shibboleth
/usr/sbin/shib-keygen -o . -h $hostname
mv sp-key.pem $hostname.pem
mv sp-cert.pem $hostname.cert

#Get Linux XML config file from Open Systems and configure it
mv shibboleth2.xml shibboleth2.xml.bak
wget http://open-systems.ufl.edu/files/linux.shibboleth2.xml -O shibboleth2.xml

sed -i "s/$hostname_replace/$hostname/g"
sed -i "s/$urn_replace/$shib_urn/g"
