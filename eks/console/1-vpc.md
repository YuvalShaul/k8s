## Step 1: Create a VPC for you EKS instance

### What should I configure (explanations later)

- Create a VPC with CIDR 10.0.0.0/16
- Create and attach an Internet Gateway (IGW)
- Make sure you have 2 routing tables: one public, one private  
(you can use the default RT as one of these)
- Create 2 public subnets in different AZs
  - name: pub1  AZ: us-east-1a IP: 10.0.1.0/24
  - name: pub2  AZ: us-east-1b IP: 10.0.2.0/24
  - Attach public RT to both
  - After creation, edit subnet settings and make sure IPv4 auto assign of public ip addresses is on.
- Create 2 private subnets:
  - name: priv1  AZ: us-east-1a IP: 10.0.3.0/24
  - name: priv2  AZ: us-east-1b IP: 10.0.4.0/24
  - Attach private RT to both
- Nat-GW:
  - Create a Nat-GW in subnet pub1
  - Add a default route to the private RT that points to this Nat-GW


### Why we need a VPC
- AWS VPC will provide the basic networking eks cluster needs, including communication between pods and nodes.
- The default way to use networking in eks is by using the [default CNI for eks](https://docs.aws.amazon.com/eks/latest/best-practices/vpc-cni.html)
- This is the default (and most used) so this is the networking you'll get if you don't install and configure anything else.


### Why a new VPC for eks?
- We could use a single VPC (including the default VPC) for EKS along with other AWS resources.  
EKS doesn't require a dedicated VPC - it just needs subnets with proper configuration.
- But it would not be a good idea in practice for several reasons:
  - **Security isolation:**  
  Different workloads should be network-isolated. Your EKS cluster might need different security group rules than your web servers or databases.
  - **IP address management:**  
  EKS can consume many IP addresses, especially with large node groups or many pods. Sharing a VPC increases the risk of IP exhaustion.
  - **Network policies:**  
  EKS often requires specific routing, NAT gateway configurations, or load balancer setups that might conflict with other services.
  - **Blast radius:**  
  Issues in one service (like a misconfigured security group) could affect your entire infrastructure.


### How would networking work for eks

- Pods get IP addresses directly from your VPC CIDR range
- Nodes get IP addresses from the same CIDR range
- Worker nodes pre-allocate ENIs (Elastic Network Interfaces) and IP addresses from your subnets
- This means pods can communicate directly with other VPC resources without NAT
- Pods can also talk to nodes that way.
- Note: You can change all this, but we'll stick to this basics in our configuration.


