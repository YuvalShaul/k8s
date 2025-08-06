
## Step 2: Create IAM roles

### Service attached roles
- When you (later) create the eks cluster, aws will create several roles that are attached to this service
  - You don't have to create these roles
  - You cannot edit them (e.g add or delete policies)
  - and you can delete them after you're done with your eks cluster

### What should I configure
- ..BUT YOU WILL HAVE TO CONFIGURE TWO ROLES:
  - EKS Cluster Service Role:  
  - EKS Node Group Role:
- The names of these roles are not important
- you will have to specify the role when you create the cluster


#### EKS Cluster Service Role
- Create a new IAM role
- **Select trusted entity**
  - Choose: **AWS Service** as the trusted entity
  - Choose: **eks** as the service
  - Choose **eks cluster** as the use case  
  (it will help the console suggest policies later)
  - hit next
- **Add permissions**
  - Suggested policy is already added for you (should be: **AmazonEKSClusterPolicy**)
  - hit next
- **Name, review, and create**
  - Role name: **MyEKSClusterRole**
  (note that this is a name you can choose)
  - Click **create* Role*
- **Explanation**:  
This roles allows the new cluster control-plane (which is under the global aws service) do things that affect my specific cluster - in my account.



#### EKS Node Group Role
- Create a new IAM role
- **Select trusted entity**
  - Choose: **AWS Service** as the trusted entity
  - Choose: **EC2** as the service
  - Choose **EC2** as the use case  
  - hit next
- **Add permissions**
  - Add these 3 aws-managed policies
    - AmazonEKSWorkerNodePolicy
    - AmazonEKS_CNI_Policy
    - AmazonEC2ContainerRegistryReadOnly
  - hit next
- **Name, review, and create**
  - Name: **MyEKS_NodeGroupRole**  
    (note that this is a name you can choose)
  - Make sure you see the 3 policies you have added before
  - Click **Create role**
- **Explanation**:  
This role will allow you **worker nodes** do things (pull ECR images, register to the controle plane etc.)