## Step 4: Compute for the EKS cluster

#### Configure managed node groups
- Navigate to your EKS cluster in the AWS Console
  - So click on it (to see the tabs)
  - Go to the Compute tab
  - Click Add node group
- Node group configuration
  - Name: learning-nodes or similar
  - Node IAM role: Select the role you have created for node groups
- Compute and scaling configuration:
  - Instance types: Select t3.small (good balance of cost/performance for learning)
  - Capacity type: Choose Spot (60-90% cheaper)
  - Scaling configuration:
    - Minimum size: 0 (allows scaling to zero)
    - Maximum size: 1 or 2
    - Desired size: 1
  - hit next
- Networking:
  - Select ONLY PRIVATE SUBNETS
  - hot next
- review and create
  - This may take several minutes (5-15 minutes!!!)
  - Just remember that eks has to install each node components:
    - kubelet, containerd, kube-proxy...
    - join the cluster
    - run health checks...


