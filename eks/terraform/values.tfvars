# terraform/terraform.tfvars.example
# Copy this to terraform.tfvars and modify as needed

region       = "us-west-2"
cluster_name = "my-learn-eks"

admin_users = [
  "arn:aws:iam::647000152682:user/yuval"
]