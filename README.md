# Create AWS Instance and provision wordpress using ansible

This is a simple project which creates AWS infrastructure (VPC, subnets, ec2 instance, security group) using terraform 
and provision wordpress in the instance using ansible, after running `terraform apply` you can directly access the installation page of
wordpress from web browser. The ansible role will be run directly after infrastructure creation by terraform, the ansible will do the lamp installation, 
mysql setup and wordpress configurations.

## How to run

### Prerequisites

* terraform
* Ansible
* Create and download ssh key from AWS

1. Clone the git repository

```console
git clone https://github.com/mathewseby/wordpress.git
```

2. Update [vars.tfvars](./vars.tfvars) with neccessary data

3. Update ansible roles variable (sample variable values are added in [defaults](./playbooks/roles/wordpress/defaults/main.yml)) file in wordpress roles folder)

4. Configure aws cli, use access key and secret key
```
aws configure
```
5. Run terraform

```
terraform init
terraform apply --var-file vars.tfvars
```