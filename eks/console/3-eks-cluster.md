## Step 3: Creating the EKS cluster

#### Configure cluster
- Go to EKS console
- Select **Custom configuration**
- for name use: **myEKS**
- Select the cluster service role you created
- Leave everythine else in this page to its defaults
- hit next

#### Specify networking

- Choose your VPC and subnets (both public and private)
- **DO NOT CHOOSE THE DEFAULT VPC Security Group, LET EKS CRETAE ONE FOR YOU**
- Cluster endpoint access:  
Choose pulic and private, so that you can connect to the cluster (kubectl) from your laptop
- hit next
- Skip Metrics and Control Plane logs and hit next

#### Select Add-Ons

- Leave everything as it is
- hit next
- Don't configure anything in the **Configure selected add-ons settings**
- hit next
- Review and create - hit on create
- This could take several minutes (10-15)
- **Wait for this to complete !!!**  
**Do not create node groups yet!!!**

