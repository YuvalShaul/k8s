## Running EKS using Terraform

### Introduction
- This is a configuration to run a complete simple EKS cluster
- A vpc module call creates:
  - A VPC with:
    - Internet Gateway (IGW)
    - 3 routing tables:
      - The default one (not used)
      - A public RT
      - A private RT
    - 2 public subnets (pub1, pub2)
      - (we add a default route to the public RT, pointing to the IGW)
    - a Nat-GW in pub1
    - 2 private subnet
      - (we add a default route to the private RT, pointing to the Nat-GW)
- An eks module call creates: 
  - 2 IAM roles:
    - EKS Cluster Service Role (the name is not mandatory), with the following aws managed IAM policy:
      - AmazonEKSClusterPolicy 
    - EKS Node Group Role (that we can call whatever we like), with the following aws managed poicies:
      - AmazonEKSWorkerNodePolicy
      - AmazonEKS_CNI_Policy
      - AmazonEC2ContainerRegistryReadOnly
  - An EKS cluster
  - A single managed node group with 0-2 nodes, made from t3.small instances (spot)

### To run
- Init a terraform configuration 
```
terraform init
```
This will create the .terraform directory install the aws provider.
- Plan your configuration:
```
terraform plan
```
This will show you what is going to be created.
- Apply:
```
terraform apply
```
This will create everything.  
(expect 15 minutes or more)

### Don't forget to delete 
- This configuration creates some aws services/resources that'll cost you some money:
  - 1 Nat Gateway
  - An EKS cluster (billed even if no instances are present)
  - EC2 instances
- Fortunatelly, if you have created your cluster using terraform, you can delete everything with a single command:
```
terraform destroy
```

Enjoy


