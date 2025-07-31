## Step 5: Configure kubectl
- We'll be using the **aws** cli command
- This is a good alternative, as you will get to work with aws cli sometime..
- Install AWS CLI and kubectl locally:
  - Install aws cli as explain in [this page](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
  - install kubectl as explained in [this page](https://kubernetes.io/docs/tasks/tools/#kubectl)
- Run this command:
```
aws eks update-kubeconfig --region <your-region> --name <cluster-name>
```

