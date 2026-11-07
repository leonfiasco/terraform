# AWS Dev Environment via Terraform

## Overview

This project uses **Terraform** to provision a complete, reusable development environment on AWS. It demonstrates Infrastructure as Code (IaC) principles by automating the setup of a Virtual Private Cloud (VPC) and a secure EC2 instance, eliminating the need for manual configuration in the AWS Console.

## Architecture

The infrastructure consists of the following AWS resources:

- **VPC:** A dedicated Virtual Private Cloud (`10.123.0.0/16`) with DNS hostnames and support enabled.
- **Public Subnet:** A subnet (`10.123.1.0/24`) configured to auto-assign public IPs for external access.
- **Internet Gateway (IGW):** Attached to the VPC to allow communication with the internet.
- **Route Table & Association:** Routes outbound traffic (`0.0.0.0/0`) to the IGW and associates it with the public subnet.
- **Security Group:** Acts as a virtual firewall. Ingress is strictly limited to the deploying user's IP address to minimize the attack surface.
- **EC2 Instance:** An Ubuntu server (`t3.micro`) deployed into the public subnet.
- **Key Pair:** Automatically uploads a local public SSH key to AWS for secure instance access.
- **User Data:** A template file (`userdata.tpl`) that automatically installs and configures software on the EC2 instance at boot time.
- **Local Exec Provisioner:** Automatically generates an SSH configuration file on the local machine for seamless connection to the new instance.

## Prerequisites

Before deploying, ensure you have:

- [Terraform installed](https://developer.hashicorp.com/terraform/downloads) (v1.0.0+)
- [AWS CLI installed and configured](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) with an active profile.
- An SSH key pair generated on your local machine (e.g., `~/.ssh/mtckey` and `~/.ssh/mtckey.pub`).

## Usage

**1. Clone the repository:**

```bash
git clone https://github.com/yourusername/terraform-aws-dev-env.git
cd terraform-aws-dev-env
```

**2. Configure Variables:**
This project uses variables to keep sensitive data out of version control. Create a `terraform.tfvars` file in the root directory and add your specific values:

```hcl
my_ip         = "YOUR_PUBLIC_IP_ADDRESS" # e.g., "203.0.113.50"
instance_type = "t3.micro"
aws_region    = "us-east-1"
```

_(Note: You can find your public IP by searching "what is my ip" in your browser)._

**3. Initialize Terraform:**

```bash
terraform init
```

**4. Review the execution plan:**

```bash
terraform plan
```

**5. Deploy the infrastructure:**

```bash
terraform apply
```

Type `yes` when prompted.

**6. Connect via SSH:**
Once deployment is complete, Terraform will automatically generate an SSH config block. You can connect to the server using:

```bash
ssh dev-node
```

## Cleanup

To avoid incurring AWS charges, destroy the infrastructure when you are finished:

```bash
terraform destroy
```

## Security & Best Practices Implemented

- **No Hardcoded Secrets:** Public IP addresses and instance types are managed via variables. The `terraform.tfvars` file is ignored via `.gitignore`.
- **State Management:** `.tfstate` files and `.terraform` provider binaries are ignored to prevent repository bloat and state corruption.
- **Least Privilege Networking:** The Security Group restricts inbound traffic to a single `/32` IP address rather than opening ports to the world (`0.0.0.0/0`).
