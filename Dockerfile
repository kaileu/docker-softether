# SoftEther VPN server
#docker create -v /home/docker/soft-ether/config/.charles:/root/.charles -v /home/docker/soft-ether/config/vpn_server.config:/usr/local/vpnserver/vpn_server.config  -v /home/docker/soft-ether/logs/:/var/log/vpnserver -p X.X.X.X:443:443/tcp -p X.X.X.X:992:992/tcp -p X.X.X.X:1194:1194/tcp -p X.X.X.X:1194:1194/udp -p X.X.X.X:5555:5555/tcp -p X.X.X.X:500:500/udp -p X.X.X.X:4500:4500/udp  --restart always --cap-add NET_ADMIN --name vpn localvpn

FROM ubuntu:16.04
MAINTAINER Kai Leutner <git@kleutner.de>

#ENV VERSION v4.18-9570-rtm-2015.07.26
#ENV VERSION v4.19-9599-beta-2015.10.19
ENV VERSION v4.22-9634-beta-2016.11.27
WORKDIR /usr/local/vpnserver


RUN apt-get update &&\
        apt-get -y -q install iptables apt-transport-https gcc make wget && \
		wget -q -O - https://www.charlesproxy.com/packages/apt/PublicKey | apt-key add - && \
		sh -c 'echo deb https://www.charlesproxy.com/packages/apt/ charles-proxy main > /etc/apt/sources.list.d/charles.list' && \
		apt-get update && \
		apt-get -y -q install charles-proxy && \
        apt-get clean && \
        rm -rf /var/cache/apt/* /var/lib/apt/lists/* && \
        wget http://www.softether-download.com/files/softether/${VERSION}-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-${VERSION}-linux-x64-64bit.tar.gz -O /tmp/softether-vpnserver.tar.gz &&\
        tar -xzvf /tmp/softether-vpnserver.tar.gz -C /usr/local/ &&\
        rm /tmp/softether-vpnserver.tar.gz &&\
        make i_read_and_agree_the_license_agreement &&\
        apt-get purge -y -q --auto-remove gcc make wget

ADD runner.sh /usr/local/vpnserver/runner.sh
RUN chmod 755 /usr/local/vpnserver/runner.sh

EXPOSE 443/tcp 992/tcp 1194/tcp 1194/udp 5555/tcp 500/udp 4500/udp

ENTRYPOINT ["/usr/local/vpnserver/runner.sh"]
