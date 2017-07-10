echo ******Copying network interfaces****
echo ****Must be root user****
echo resolvconf is needed for dns
echo The install disk may need to be inserted for this step
apt-get -y install resolvconf
echo Edit the interfaces to match the correct server ip settings
vim.tiny network/interfaces
cp /etc/networks/interfaces /etc/networks/interfaces.bak
cp network/interfaces /etc/network/interfaces
chown root:root /etc/network/interfaces
service networking restart

if ping -q -c 1 -W 1 google.com >/dev/null; then
    echo "The network is up"
else
    echo "The network is down"
fi

