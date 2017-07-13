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
sed -i "s/SSLCerticateFile .*/SSLCertificateFile $cert_dir/$cert_name"
sed -i "s/SSLCerticateKeyFile .*/SSLCertificateFile $cert_dir/$key_name"
service apache2 reload

#Test if SSH seems to be working
echo quit\n >> quit.txt
openssl s_client -connect $host_name:443<quit.txt > ssl.txt
grep -A 30 ssl.txt
