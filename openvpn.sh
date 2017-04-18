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
    echo "argument error, usage: './openvpn -c' or './openvpn -s' or './openvpn --client' or './openvpn --server' "        # unknown option
    exit 1
    ;;
esac

if [ "$configure" = client ];
then
    echo "client"
    echo "dev tun \nproto tcp-client \nremote $serverDomain \nifconfig $clientVPNIP $serverVPNIP \nkeepalive 60 600 \nsecret /etc/openvpn/static.key" | sudo tee /etc/openvpn/$clientConfigFileName > /dev/null
    echo AUTOSTART=\"all\" | sudo tee -a /etc/default/openvpn >> /dev/null
else
    echo "server"
    sudo openvpn --genkey --secret /etc/openvpn/static.key
    echo "dev tun \nproto tcp-server \nlocal 0.0.0.0 \nifconfig $serverVPNIP $clientVPNIP \nkeepalive 60 600 \nsecret /etc/openvpn/static.key" | sudo tee /etc/openvpn/$serverConfigFileName > /dev/null
    echo AUTOSTART=\"all\" | sudo tee -a /etc/default/openvpn >> /dev/null
fi

sudo /etc/init.d/openvpn restart
echo "\nNote: \n\ncopy static key from you server (/etc/openvpn/static.key) to  /etc/openvpn/ \n\nIn /etc/ssh/sshd_config change \"PubkeyAuthentication no\" (line number 32) and uncomment \"PasswordAuthentication yes\" (line number 52) \n\nYou might have to install ssh using \"sudo apt-get install ssh\" if you can find the ssh folder"
