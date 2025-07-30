
## Step 2: Create IAM roles

### What should I configure
You'll need two roles:
- EKS Cluster Service Role:  
- EKS Node Group Role:

#### EKS Cluster Service Role
- Create a new IAM role, and call it **AmazonEKSClusterRole**  
(actually the name is not really important, we could use other names and configure the cluster to use whatever names we chose)
- This is assumed by the global AWS-EKS service itself to do things for the cluster. 
- Add this AWS managed policy: **AmazonEKSClusterPolicy** to the role

#### EKS Node Group Role
- Create a new IAM role, and call it **awsEKSNodeGroupRole**  
- This is assumed by the AWS-EC2 service,  instances that make up your worker nodes.
- Add these 3 aws-managed policies
  - AmazonEKSWorkerNodePolicy
  - AmazonEKS_CNI_Policy
  - AmazonEC2ContainerRegistryReadOnly