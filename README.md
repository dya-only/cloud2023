### 1. VPC(with subnets, igw, ngw, route tables, eips)
 - route table: 2 works(routes, subnet associations)

### 2. EC2 Bastion (public a)
 - keypair
 - elasic ip: enable
 - ssh, **anywhere**
 - iam role
 - associate elastic ip

### 3. Launch Template
 - sg TCP: 80
 - sg **Custom**: 0.0.0.0/0
 - user data
