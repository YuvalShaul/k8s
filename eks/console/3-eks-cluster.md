## Step 3: Creating the EKS cluster

### This is what you should be configuring

- Click on **Create cluster**
- **Configure cluster**
  - Select **Custom configuration** (this is not the default!!!)
  - disable **EKS Auto Mode**
  - name: **myEKS**
  - Select the cluster IAM role you created  
  You may see several other policies that aws would like you to add - but you can add these to the role later when needed.
  - Choose Kubernetes version 1.32 (we had some problems with 1.33)
  - hit next
- **Specify networking**
  - Choose your VPC
  - Add ALL subnets (both public and private)
  - **DO NOT CHOOSE THE DEFAULT VPC Security Group, LET EKS CRETAE ONE FOR YOU**  
  **SO LEAVE THIS EMPTY**
  - hit next
- **Metrics**
  - hit next
- **Select add-ons**
  - hit next
- **Configure selected add-ons settings**
  - hit next
- **Review and create**
  - hit **Create**

### Cluster creation

- This could take several minutes (10-15)
- **Wait for this to complete !!!**  
- **Do not create node groups yet!!!**

