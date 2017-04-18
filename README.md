# VPN

This shell script creates VPN between two machines using [OpenVPN](https://en.wikipedia.org/wiki/OpenVPN).

## History

In one of my projects, I had linux machines running in my home. I had no way to access them (SSH) from external network. However they were all connected to my Virtual Machine in Digital Ocean which had public IP. So I came up with a plan of setting up VPN between my Could host VM and the Linux machines at home, so that I can SSH into them using the IP that VPN has.

For more information please refer [Implementing End-To-End IoT Value Chain](https://raghavendramanjegowda.com/wp/smartplatformdevelopment-endtoend/).

## Installation

```shell
## Make the shell script executable
$ chmod +x openvpn.sh
```
### Edit the file and change User Name and Domain Name (IP address of your server)

#### To configure openvpn server

```shell
$ ./openvpn.sh -s
```
#### To configure openvpn client

```shell
$ ./openvpn.sh -c
## After execution a note is displayed on copying the static key for VPN authentication and SSH password authentication"
```


## Usage

```shell
## Check for tun0 connection under ifconfig
$ ifconfig
## ssh to your client from server
$ ssh user@10.8.0.4
```
