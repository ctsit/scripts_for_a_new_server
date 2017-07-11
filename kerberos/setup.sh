working_dir=$1
apt-get -y install krb5-user libpam-krb5
cd /etc/pam.d/
sed -i -e s/uid=1000/uid=900/ *
mv /etc/krb5.conf /etc/krb5.conf.bak
cp $working_dir/kerberos/krb5.conf /etc/
chown root:root /etc/krb5.conf
pam-auth-update --package krb5 unix
