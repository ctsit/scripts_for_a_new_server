#This script requires two arguments:
#$1 is the directory of this project
#$2 is the hostname of this server

script_dir=$1
hostname=$2

echo This script will install apache2 with SSL enabled and a self-signed cert
# Per https://www.digitalocean.com/community/tutorials/how-to-create-a-ssl-certificate-on-apache-for-debian-8

cert_dir=/etc/apache2/ssl
cert_name=apache.crt
key_name=apache.key
host_name=

#Install Apache and Enable SSL
apt-get install apache2
a2enmod ssl
a2ensite default-ssl
service apache2 reload

#Create Self-signed Cert
mkdir $cert_dir
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $cert_dir/$key_name -out $cert_dir/$cert_name -subj "/C=US/ST=Florida/L=Gainesville/O=OrgName/OU=IT Department/CN=$host_name"
chmod 600 $cert_dir/*

#Configure Apache to use SSL
cd /etc/apache2/sites-enabled/
sed -i '/ServerAdmin/ s/$/\n                 ServerName $host_name:443/' default-ssl.conf
sed -i "s:SSLCertificateFile .*:SSLCertificateFile $cert_dir/$cert_name:"
sed -i "s:SSLCertificateKeyFile .*:SSLCertificateFile $cert_dir/$key_name:"
service apache2 reload

#Test if SSH seems to be working
cd $script_dir/output/
echo quit\n > quit.txt
openssl s_client -connect $host_name:443<quit.txt > ssl.txt
grep -A 30 "Session" ssl.txt

#clean up
rm quit.txt