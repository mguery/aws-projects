# AWS projects


# Project: Build a 3-tier architecture
- can update 1 tier w/o messing up the other tiers
- scale up or down/horizontally to support the traffic (add ec2 instances)
- for security - users can only reach the 1st layer and you can hide the other layers in a private sn
- high availibility - host in another AZ, increase performance, highly reliable, cost optimization
- fault tolerant - one instance is down, other instance can take over


# VPC Info
- max 5 per region
- max 5 CIDR per vpc
- 200 subnets per vpc
- 5 EIPs per acct per region
- 1 IGW per vpc
- min is /28 = 16 IPs, max is /16 = 65,536 IPs
- 5 Ips reserved by AWS 1st and last Ip
- no overlapping cids with other networks
- Lower the #, the more Ips 
- CIDR to IPv4 Conversion - https://ipaddressguide.com/cidr 
  - a CIDR block is a defined range of IPv4 addresses. the slash (/24) number of bits shared (/24 = 24-bit prefix), primiary block for ex - 10.0.0.0/16

- /32 = 1 IP
- /24 = 256 IPs
- /16 = 65536 IPs
- /0 = allows all IPs

Only private IP ranges allowed
- 10.0.0.0/16 (10.0.0.0 - 10.0.255.255), Total host - 65,536
- 172.16.0.0/12 (172.16.0.0 - 172.31.255.255), Total host- 1,048,576
- 192.168.0.0/16 (192.168.0.0 - 192.168.255.255), Total host - 65,536

---

Watch video: https://youtu.be/ccmWbVjZMkk

[![Build a VPC](https://j.gifs.com/793r28.gif)](https://youtu.be/ccmWbVjZMkk)


## Step 1: Create VPC
virtual private cloud (VPC) - isolated virtual network where you can define your own space and control/manage/organize your ntwk and resources / pay for the resources used like ec2i

from [vpc console](https://console.aws.amazon.com/vpc/home?region=us-east-1#vpcs:), click create vpc
- name tag - DemoVPC
- IPv4 block - 10.0.0.0/16
- IPv6 cidr block - no block or Amazon-provided IPv6 CIDR block
- Tenancy - default
- Create VPC
- right click new vpc - enable dns hostname

## Step 2: Create subnets

- Subnet - when you define a subset/smaller range of IPs from primary cidr block
- public subnet - subnet that's associated with a route table that has a route to an internet gateway
tied to AZ, define a subset/smaller range of IPs from primary cidr block / 1st 4 ips and last ip address in each subnet are reserved for networking / no overlapping ip ranges / you need a public ipv4 or elastic ip
- private subnet - a subnet with no route to the IGW, public ips or EIP. can only access the internet thru a nat gw (which is inside of the ppublic sn)

will create 2 subnets per az - public and private
from [subnets](https://console.aws.amazon.com/vpc/home?region=us-east-1#subnets:), create subnet
- choose vpc
- name - 'Public-Subnet-A', A/B/C = 1 for each az
- choose az - us-east-1a (A/B/C)
- IPv4 cidr block - 10.0.0.0/24 
- Tags
- Add new subnet or Create subnet
- right click public sn - Modify auto-assign IP settings > check Enable auto-assign public IPv4 address > save

Example values for a VPC in 3 AZs
- 'Public-Subnet-A' > us-east-1a > 10.0.1.0/24 
- 'Public-Subnet-B' > us-east-1b > 10.0.2.0/24
- 'Public-Subnet-C' > us-east-1c > 10.0.3.0/24

- 'Private-Subnet-A' > us-east-1a > 10.0.4.0/24 
- 'Private-Subnet-B' > us-east-1b > 10.0.5.0/24
- 'Private-Subnet-C' > us-east-1c > 10.0.6.0/24

## Step 3: Create route tables
Route table - A list of CIDR blocks (IP ranges) that our traffic can leave and come from
each sn is associated with a rt. A set of rules called routes that are used to determine where network traffic is directed. associate which each sn to a route table (public sn -> public RT)

Create 2 RTs - public and private. associate rt with correct subnet. from [rt page](https://console.aws.amazon.com/vpc/home?region=us-east-1#RouteTables:sort=routeTableId)

For Public RT
- choose rtb created from demo
- right click edit name - Public-RT
- right click > edit subnet associations, pick public subnets, save 

For Private RT
- create route table 
- name tag - Private-RT
- choose VPC
- Create
- right click > edit subnet associations, pick private subnets, save

## Step 4: Create IGW
allows the VPC to connect to the internet and other AWS services. provides ipv4 and ipv6. scales horiz, ha, redundant, created seperate from vpc. 1 igw per vpc. public address and placed in public sn can connect to internet. after you attach igw, need a route w/tin each public sn with destination as 0.0.0.0/0 and a target of igw-#####, the id og the igw [notes from here](https://medium.com/@mda590/aws-routing-101-67879d23014d)

from [igw console](https://console.aws.amazon.com/vpc/home?region=us-east-1#igws:), create igw
- name - demo-igw
- create internet gateway
- attach to vpc - Actions dropdown - attach to VPC > Attach igw

Route tables
- right click, edit routes > add route - 0.0.0.0/0
- choose target - igw
- save routes

## Step 5: Create NAT GW (Network Address Translation)
Subnets connected to the Private Route Table need access to the internet, so set up a NAT Gateway in the public Subnet. (IPv4 only) This allows the NGW to connect through the internet gateway to the public internet and translate the private addresses of the resources in the private subnets into a public address that can be used to connect to the outside internet. 
- destination as 0.0.0.0/0 and a target of ngw-#####. best practice to create 1 NAT gateway within the public subnet of each availability zone, and then point the route tables in AZ A to the NGW created in AZ A; same concept for AZ B.
- must specify the public subnet in which the NAT gateway should reside.
- must specify an Elastic IP address (static, public IPv4 address.) to associate with the NAT gateway when you create it.
- NAT gateway uses ports 1024-65535. Make sure to enable these in the inbound rules of your network ACL.
- All IPv6's are internet accessible by default, so the way you make them "private" is by directing traffic out through an Egress Only Internet Gateway (outgoing traffic only). 

from [nat gw page](https://console.aws.amazon.com/vpc/home?region=us-east-1#NatGateways:), create ngw
- name - demo-ngw
- choose subnet - public
- Elastic IP allocation ID - click allocate eip
- create ngw

[Route tables](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)
- right click private rt - edit subnet associations, pick private subnets, save
- right click > edit routes
- add route - 0.0.0.0/0
- choose target - ngw
- save routes

## Step 6: Security
To protect the AWS resources in each subnet, you can use multiple layers of security, including security groups and network access control lists (ACL).

sg 
- firewall for instances - controls inbound and outbound traffic instances, created by default
- if you don't specify, instance uses default sg. all inbound traffic is set to deny. new sg has no inb rules.
- stateful filtering - allow config inbound rules only bc it remembers which packet enters the ntwk and will allow outbound traffic from same port, best practice - allow only traffic reqd (least privilege)
- edit demo sg - Inbound rules - SSH, source - 0.0.0.0/0

nacl
- firewall for subnets - controls inbound and outbound traffic for your subnets and services that use EC2 as a backend (global firewall)
- has a numbered list of rules - determines whether traffic is allowed in or out, starts with lowest # which is highest priority then works way down to next item
- custom nacls - add rule for ephemeral ports (temp ports, 32762-65535 range), if you have a ngw, elb, or lambda func, enable 1024-65535 port range
- stateless filtering - remembers the source or dest ip address and dest port (have inbound rule then need an outbound rule) / use as extra layer of sec with a sg / created by default 

flow log
collects info about ip traffic going to and from your vpc, published to CW logs and can be sent to s3 buckets / diagnose restrictive sg rules, monitor traffic, determine direction of traffic / doesnt affect ntwk thruput or latency / no realtime data collected or IP traffic to or from these addresses

- select VPC
- create FL, name - demo-fl
- filter - accept, reject, or all
- destination - send to s3 bucket or CW logs
- log record format - aws default
- create flow log

## Step 7: Launch EC2 instance
from [ec2 page](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Home:), launch instance
- select Amazon Linux 2 AMI (free tier)
- choose instance type - t2.micro, next
- configure instance details - choose vpc, choose public subnet, make sure auto-assign public ip enabled, next - add storage
- next: add tags
- next: configure security group - select an existing sg - your sg id, review and launch, launch
- select key pair and click launch instances or create new key pair and download key pair, and launch
- rename ec2 instance 

## Step 8: Connect
- Choose ec2 instance
- click Connect
- EC2 Instance Connect, Connect
- ping google.com
- Ctrl+c to cancel

For SSH Client - follow instructions (reminder - cd into folder with .pem file)

---
Remember to delete/terminate after finished. delete vpc, delete ec2 instance, release elastic ips, s3 bkts, nat gw, flow logs

terminate ec2 instances
delete nat gw, wait until deleted state
release eip
delete vpc - deletes vpc, rts, subnets, igw

---
## Add a PostgreSQL DB

Pre-work - follow steps above to create VPC. Same steps, plus create a second security group for private access. Add inbound rules to your VPC security group that allow traffic from your web server only. Inbound rules - allow DB traffic on port 3306 to connect from your web server to your DB instance to store and retrieve data from your web application to your database.


**Create a DB instance**
1. Go to [RDS console](https://console.aws.amazon.com/rds/) 
2. Create database
3. Choose Standard create 
4. Choose Engine (MySQL, PostpreSQL - free tier compatible)
5. Use recent version populated
6. Templates - free tier
7. DB instance identifier - my-vpc-db
8. Master username - mypostgres
9. Master password
10. Confirm password
11. DB instance class - burstable classes, db.t2.micro
12. Storage - use defaults - GP SSD / 20gb / uncheck autoscaling
13. Availibility and durability - use defaults, (multi-az for in prod best practice)
14. Connectivity - choose your vpc, subnet groups
15. Public access - no
16. VPC security group - choose existing
17. Choose AZ 
18. Additional configuration - default 3306 for MySQL, 5432 for Postgresql
19. Database authentication - select Password authentication
20. Database options - initial db name - my-rds-db Default settings - Enable auto-backup, 7 days, backup window - no pref, maintenance - enable auto minor version upgrade, window - no pref, deletion protection (uncheck for your projects or you cant delete)
21. Create database, wait for Available status
22. Connectivity & security section, view the Endpoint and Port of the DB instance. Use the endpoint and port to connect to web server to DB instance

Create an EC2 instance and install web server
Follow steps in EC2 section. Add Storage - default, Tags - my-web-server
Next Configure SG, select exisiting, choose create in pre-work. SG you choose includes inbound rules for SSH (22) and HTTP access (80). Review and launch.


---

# Project: Build a VPC with CloudFormation

[Link to CFN file](https://github.com/mguery/aws-projects/tree/main/cfn)

## Steps 
1. Create stack
2. Template is ready
3. Upload a template file
4. Choose file and upload, Next
5. add Stack name 
6. Add Parameters, Next
7. Add Tags - optional
8. Add Permissions - create role if its not a root user, Or leave default, next
9. Advanced options - default settings, Next
10. Review, then Create stack
11. Cfn Stacks page - under Events see resources launching
12. If you make changes to template file, from your new Stack, under Stack actions, create a changeset for current stack
13. Replace current template
14. Upload file, repeat steps, Create, Create change set
15. Clean up - delete the stack and aws deletes all resources from stack

# Project: Build a VPC with Terraform

[Link to project](https://github.com/mguery/aws-projects/tree/main/terraform)

## Steps
1. Create 'main.tf' to add aws resources
2. Create 'terraform.tfvars' to add vars
3. Commands - `terraform init`, `terraform plan`, `terraform apply`, `terraform destroy`

