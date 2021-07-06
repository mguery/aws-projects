# Networking  

- network - used to connect the networks or it routes traffic between the networks. Router is the Gateway of a network
- router - piece of network hardware responsible for forwarding packets to their destinations / a gateway out to the internet (default gateway), routes data packets based on their IP addresses, connects LANs and WANs together
- switches - maintains a Switch table which has the MAC addresses of all the devices connected to it, can connect the devices only in the same network
- hubs - mainly used to create a network and connect devices on the same network only
- wireless routers - 802.11a/b/g/n/ac - FROM a = 54Mbps, 5 GHz freq TO n = 100Mbps, 5 or 2.4 GHz
- firewalls - fw in front of a router, stop traffic coming in using fw rules
  - AWS - Security Groups - firewall rules. controls how traffic is allowed in and out of EC2 instance. SGs only allow rules. Can reference by IP or by SG. Regulates - access to ports, IP ranges, control in/outbound traffic // www -> sg -> ec2 instance -> sg -> www
- IPS vs IDS - intrusion prevention system / intrusion detection system 
- forward vs reverse proxy - fwd proxy -> thru proxy server -> internet (for tracking and logging, caching) / rev proxy - internet -> proxy svr -> machine (for sec purposes, not expose your machines to the internet) 


**Networking 101**

- DHCP server (dynamic host configuration protocol) - dynamically give out IP addresses, [DORA process](https://www.gns3network.com/what-is-dora-process-in-dhcp)

![image](https://user-images.githubusercontent.com/10605985/120259239-94dc1680-c261-11eb-933e-bbd838fb0fea.png)
 
- DNS - see DNS section below (TL;DR - browser -> router -> query dns server -> from server, IP address is passed back to router -> back to your local machine) 
- IP addresses
  - IPv4 - 192.168.1.1 -> 32-bit binary -> 4 octets -> 1 octet = 8 bits = one byte (4 groups of up to 3 decimal digits)
  - Every IP has a network ID and host ID.
  - Subnet masks - 192.168.1.1 (network part) with a sm 255.255.255.0 (node part)
  - IPv6 - hexadecimal - 2001:db8::8a2e:370:7334
- Static vs Dynamic - static - hard-coded IP add / dynamic - randomly assigned IPs
- [OSI Model](https://www.imperva.com/learn/application-security/osi-model/) - describes seven layers that computer systems use to communicate over a network.

![image](https://user-images.githubusercontent.com/10605985/120267871-d1643e00-c272-11eb-9f7a-c0aeeb22f3b2.png)

- [TCP vs UDP](https://www.howtogeek.com/190014/htg-explains-what-is-the-difference-between-tcp-and-udp/) - connection based - back and forth communication with packets / connectionless - order of packets doesn't matter (Zoom, YouTube), no error checking so pkts can be lost 
- [DMZs - demilitarized zone](https://www.fortinet.com/resources/cyberglossary/what-is-dmz) - subnetwork that sits between the public internet and private networks, allows an organization to access untrusted networks, such as the internet, while ensuring its private network or LAN remains secure
- [Bastion host](https://www.geeksforgeeks.org/what-is-aws-bastion-host/) - server or an instance that is used to configure to work against the attacks or threats. AKA ‘jump box’ that acts like a proxy server and allows the client machines to connect to the remote server. GW between the private subnet and the internet. / Can use with a VPN for security?
- Ports
  - 22 - SSH (secure shell) - log into Linux instance
  - 21 FTP (file transport protocol) - upload files into a file share
  - 22 SFTP (secure file transport protocol) - upload files using SSH
  - 80 HTTP (Hypertext Transfer Protocol) - access unsecure sites
  - 443 - HTTPS (Secure HTTP) - access secured sites, encrypted
  - 3389 - RDP (Remote Desktop Protocol) - log into Windows instance
- latency - time it takes for a packet to be transferred across a ntwk / how fast
- throughout - amount of data or requests that can be sent per unit time (MBs, GBs) / how much 

**Subnetting**

Split the network to have more than 1 network available to use and control the hosts. 
- Classes
  - Public IP address / Internet IP - IP address that your home or business router receives from your ISP and is used when you access the internet. Each device has a unique IP. To hide your public IP and encrypt data, use a VPN. 
  - Private IP address / local IP address - IPs reserved for internal use behind a router or other Network Address Translation (NAT) device. You're not on the internet but have internet access. There's a limited supply of public IPs, and you can use private IPs without taking up a public IP. Common private IPs: 
    - Class A - 10.0.0.0 - 10.255.255.255
    - Class B - 172.16.0.0 - 172.31.255.255
    - Class C - 192.168.0.0 - 192.168.255.255
- 192.168.1.1 -> 32-bit binary -> 4 octets -> 1 octet = 8 bits = one byte
- Subnetting hack for class c with ex. 192.168.3.0/27 <!--(32 minus CIDR, 2 to the # power = total hosts)-->
  - 32-27 = 5 (32 = total # of octets, 27 = CIDR) 
  - 2^5 = 32 hosts

**External access**

- NAT - Network Address Translation - translates the private local IP address to the public global IP address.
- PAT - Port Address Translation - also translates the private IP addresses of an internal network to the public IP address with the help of Port numbers

**Linux DNS tools**

- **dig** - collects data and displays DNS info - `dig google.com` ``dig mx google.com` 
- **nslookup** - look up the dns query info, converts the domain name or host to IP address. - forward `nslookup google.com`, reverse `nslookup 216.58.211.142`
- **whois** - get domain registration info - who's the registered owner, address, email, registrar info, exp. date
- **ipconfig** - find your IP address - v4 and v6, subnet mask, default gateway
- **tracert** (windows) / traceroute - displays possible routes (paths) and measures time it takes to go from one dest and back (hops), pings every device `tracert google.com`
- **netstat** - IDs all active cnnx you have over the ntwk
- **ping** - test if domain can be reached, can set # of times to run `ping -t 5 google.com` (on windows)
- /etc/hosts - your host file with the hostnames, each line is an IP `127.0.0.1 localhost`

TTL - time to live - check the TTL if dns record is changed

---

## Domain Name System (DNS)

Web browsers interact thru IP addresses and translates domain names to IPs so browsers knows where to go. (Maps names to numbers, like a phonebook.)

Each device connected to the Internet has a unique IP address which other machines use to find the device.

For websites, the network is the entire internet. In DNS, an individual mapping that links an IP address to a resource is called a resource record. 

Resource records are collected into zones, which are stored on nameservers. 

A nameserver is a specialized server that handles queries about the location of a domain name’s services, such as your website or email.

A DNS resolver is the first stop in the DNS lookup, and it is responsible for dealing with the client that made the initial request.

LAN (your router) -> WAN (the ISP) / Internet Protocol (IP) gets packet to right computer, User Datagram Protocal (UDP) gets packet to right program running on that computer

<!--
aws simple - mywebsite.com in the browser -> route 53 -> elb -> ec2 -> website
aws advanced - user -> r53 -> s3 -> cloudfront (static site, cdn to improve ux) / decouple - EC2 -> RDS/Aurora (for MySQL) / EC2 -> EKS/ECS  
-->

### DNS lookup steps
- Client types google.com into a web browser and connects to an ISP via a router.
- This request/query travels into the internet and received by a DNS recursive resolver. 
- The resolver queries a DNS root nameserver.
- The root server responds to the resolver with the address of a Top Level Domain (TLD) DNS server (google.com is pointed toward the .com TLD). 
- TLD server responds with the IP address of the domain's nameserver, google.com.
- The recursive resolver sends a query to the domain's nameserver.
- The DNS resolver then responds to the web brower with the IP address of google.com.
- The browser makes a HTTP request for the web page.
- The server at that IP returns the page to be rendered in the browser (html, css, js).

![image](https://user-images.githubusercontent.com/10605985/120244451-377f9f80-c238-11eb-9530-48ba2387bb83.png)

DNS caching - stores data closer to the requesting client so that the DNS query can be resolved earlier and additional queries further down the DNS lookup chain can be avoided.

Browser DNS caching - web browsers are designed by default to cache DNS records for a set amount of time.

Request header - host (google.com), method (GET request, POST = login or posting a tweet, PUT = edit/update, DELETE request), path (/images.logo.png), cookies (string of characters, site stored this on your machine), user-agent ('Mozilla/5.0, Macintosh; Mac OS X')

Response heeaders - content type (text/html, image/jpg, application/json), status/code (200 = ok, 400 = not found, 500 = error), response body (your file or your results - name and pw)


### Common DNS records
A record points a domain to an IP address. A blank record points your main domain to a server. DNS records are sets of instructions that live on DNS servers. 

Info | example
--- | ---
A Record - host record (holds the 32-bit IPv4 address of a domain, used to map hostnames to an IP add of the host) | google.com --> 142.250.179.142 
AAAA - host record (returns a 128-bit IPv6 address, used to map hostnames to an IP add of the host) | google.com -> 2a00:1450:400e:800::200e
CNAME - Canonical name (forwards one domain or subdomain to another, used to link a subdomain to a domain’s A or AAAA record) | google.com -> mail.google.com
MX - Mail Exchange (points mail to email server that should be used to deliver mail for a domain using SMTP, and always point to a domain, not an IP address) | google.com -> aspmx.l.google.com
NS - Name server (stores the name server for a DNS entry, indicates which server is responsible for processing queries for a domain) | google.com -> ns1.google.com, ns2.google.com


### IP Routing

the process of transferring data through a path across one or more networks. this process begins when a host creates a data packet for a host that is located in another network and ends when that destination host receives the packet. hosts of different networks cannot communicate with each other. If two hosts located in different IP networks want to communicate with each other, they use IP routing. Routers provide IP routing. A router is a specialized device that connects different IP networks. Difft hosts in different IP networks need a router to communicate.

IP routing process relies on two types of protocols:
- routed protocol - an IP protocol, by using this, a source host packs data pieces and adds the source address and the destination address on each data piece. A data piece with both addresses (source and destination) is known as the IP packet.
- routing protocols - to figure out all available paths of the network. A router stores these paths in a table called a routing table

[IP routing?](https://study-ccna.com/what-is-ip-routing)
When you send packets from 1 host on 1 ntwk to another host on another remote ntwk. Process is done by routers, where routers determines the IP address of a pkt, the next hop address, and fwd the pkt. Rtrs use rting tables to determine the next hop add where the pkt should be forwarded. 

> Example: Host A wants to communicate with host B, but host B is on another network. Host A is configured to send all packets destined for remote networks to router R1. Router R1 receives the packets, examines the destination IP address and forwards the packet to the outgoing interface associated with the destination network.

**Default gw** - an interface of a router that connects the local network with the remote network. used when a host doesn’t have a route entry for the specific remote network and doesn’t know how to reach that network. Hosts can be configured to send all packets destined to remote networks to the default gateway, which has a route to reach that network.

**Routing table** - Each router maintains a routing table and stores it in RAM. A routing table is used by routers to determine the path to the destination network. Each routing table consists of the following entries:
- network destination and subnet mask – specifies a range of IP addresses.
- remote router – IP address of the router used to reach that network.
- outgoing interface – outgoing interface the packet should go out to reach the destination network.

There are three different methods for populating a routing table:
directly connected subnets, using static routing, using dynamic routing

[How does routing work?](https://www.cloudflare.com/learning/network-layer/what-is-routing/) when a router receives a packet, it reads the headers (small bundles of data attached to packets that provide useful info) of the packet to see its intended destination. It then determines where to route the packet based on information in its routing tables.

"Route tables consist of a list of destination subnets, as well as where the “next hop” is to get to the final destination.

Routing tables can either be static or dynamic. **Static routing** tables do not change. A network administrator manually sets up static routing tables. This essentially sets in stone the routes data packets take across the network, unless the administrator manually updates the tables.

**Dynamic routing** tables update automatically. Dynamic routers use various routing protocols to determine the shortest and fastest paths. They also make this determination based on how long it takes packets to reach their destination (think Waze). This requires more computing power, which is why smaller networks may rely on static routing. But for medium-sized and large networks, dynamic routing is much more efficient.






resources 
- [MX Toolbox](mxtoolbox.com)
- [Learn networking - CCNA study guide](https://study-ccna.com/)
- [more on ip routing - TL;DR version](https://www.guru99.com/ip-routing.html)
