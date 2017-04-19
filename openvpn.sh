#!/bin/sh

serverUserName="user"
serverDomain="domain.com" # or IP Address
clientConfigFileName="tun0.conf"
serverConfigFileName="server.conf"
serverVPNIP="10.8.0.1"
clientVPNIP="10.8.0.4"

#Install OpenVPN
sudo apt-get install openvpn

#Check the arguments to configure openvpn as client or server
case $1 in
    -c|--client)
    configure="client"
    echo "Configuring Open VPN as Client"
    shift # past argument
    ;;
    -s|--server)
    configure="server"
    echo "Configuring Open VPN as Server"
    shift # past argument
    ;;
    *)
    echo "argument error, usage: './openvpn -c' or './openvpn -s' or './openvpn --client' or './openvpn --server' "   # unknown option
    exit 1
    ;;
esac

if [ "$configure" = client ];
then
    echo "
dev tun 
proto tcp-client 
remote $serverDomain 
ifconfig $clientVPNIP $serverVPNIP 
keepalive 60 600 
secret /etc/openvpn/static.key
    " | sudo tee /etc/openvpn/$clientConfigFileName > /dev/null
    echo AUTOSTART=\"all\" | sudo tee -a /etc/default/openvpn >> /dev/null
else
    sudo openvpn --genkey --secret /etc/openvpn/static.key
    echo "
dev tun 
proto tcp-server 
local 0.0.0.0 
ifconfig $serverVPNIP $clientVPNIP 
keepalive 60 600 
secret /etc/openvpn/static.key
    " | sudo tee /etc/openvpn/$serverConfigFileName > /dev/null
    echo AUTOSTART=\"all\" | sudo tee -a /etc/default/openvpn >> /dev/null
fi

sudo /etc/init.d/openvpn restart

echo "

Note: 

In /etc/ssh/sshd_config change \"PubkeyAuthentication no\" (line 32) and uncomment \"PasswordAuthentication yes\" (line 52) 

You might have to install ssh using \"sudo apt-get install ssh\" if you cannot find the ssh folder

"

if [ "$configure" = client ];
then
    echo "copy static key from you server (/etc/openvpn/static.key) to  /etc/openvpn/ \n\n"
fi

