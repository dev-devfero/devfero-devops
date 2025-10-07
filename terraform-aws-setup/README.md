
# Terraform AWS Modular Setup

This project provisions a **secure, modular AWS infrastructure** using Terraform, including:

- VPC with public/private subnets, IGW, and NAT
- ECR for container image storage
- ECS Fargate cluster + ALB service
- IAM roles and policies
- Secrets Manager integration
- Remote S3 backend with DynamoDB state locking

Each major component is implemented as a **Terraform module** for reusability and clarity.

## Directory Structure
```
terraform-aws-setup-modular/
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── backend.tf
└── modules/
    ├── network/
    ├── ecr/
    ├── ecs/
    ├── iam/
    └── secrets/
```

To initialize your backend.tf with your state bucket and dynamodb table for state locking:
```bash
terraform init -backend-config="bucket=my-bucket" -backend-config="dynamodb_table=my-lock-table"
```

To deploy:
```bash
terraform init -backend-config="bucket=your-bucket"                -backend-config="dynamodb_table=your-lock-table"                -backend-config="region=us-east-1"

terraform plan -out=tfplan
terraform apply tfplan
```

**Note:** Always review IAM and networking configurations before production deployment.

By the way,
> **_NOTE:_** We encourage the use of modules and tools like Terragrunt to keep the code clean and you don't have to repeat yourself when creating more resources on the cloud. This is only a test and demo implemetation of some resources on AWS following a best practice for a remote backend, we also work with Azure, GCP, and other cloud providers. Please feel free to reach out to us: 

- [Devfero Info](mailto:info@devfero.cm?subject=Reaching%20out%20to%20Devfero)  
- [Devfero Dev](mailto:dev@devfero.com?subject=Reaching%20out%20to%20Devfero)