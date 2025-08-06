## Step 4: Compute for the EKS cluster

#### Configure managed node groups
- Navigate to your EKS cluster in the AWS Console
  - Click on it (to see the tabs)
  - Select the Compute tab
  - Click Add node group
- **Configure node group**
    - Name: **my-nodes** (or choose your own name)
    - Node IAM role: Select the role you have created for node groups
    - click next
- **Set compute and scaling configuration**
  - Capacity type: Choose Spot (60-90% cheaper)
  - Instance types: Select t3.small (good balance of cost/performance for learning)  
  (clear other options suggested)
  - Scaling configuration:
    - Minimum size: 0 (allows scaling to zero)
    - Maximum size: 1 or 2
    - Desired size: 1
  - hit next
- **Specify networking**
  - Select ONLY PRIVATE SUBNETS
  - hit next
- **review and create**
  - hit create

### Node  group creation
  - This may take several minutes (5-15 minutes!!!)
  - Just remember that eks has to install each node components:
    - kubelet, containerd, kube-proxy...
    - join the cluster
    - run health checks...


