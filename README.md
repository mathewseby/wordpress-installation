# Create AWS Instance with Terraform and provision Wordpress using Ansible

This is a simple project which creates AWS infrastructure (VPC, subnets, ec2 instance, security group) using terraform 
and provision wordpress in the instance using ansible, after running `terraform apply` you can directly access the installation page of
wordpress from web browser. The ansible role will be run directly after infrastructure creation by terraform, the ansible will do the lamp installation, 
mysql setup and wordpress configurations.

Note: 
* Database used for the wordpress is mariadb in this setup.
* Ansible role supports both centos and amazon-linux 2

## How to run

### Prerequisites

* terraform
* Ansible
* Disable strict host key checking in ansible config (change `host_key_checking = False` in ansible.cfg)
* Create and download ssh key from AWS

### Steps to Run

* Clone the git repository

```console
git clone https://github.com/mathewseby/wordpress.git
```

* Update [vars.tfvars](./vars.tfvars) with neccessary data

```console
instance_key_name = "<ec2-instance-key-name>"
ssh-user = "<centos>"
private_key_path = "<ec2-instance-key path>"
instance-type = "<instance-type>"
instance-ami = "<ami id of the instance>"
region = "<aws region to create resources>"
```

* Update ansible roles variable (sample variable values are added in [defaults](./playbooks/roles/wordpress/defaults/main.yml)) in wordpress roles folder)

```console
mysql_root_password: <root password>
wordpress_user_password: <wordpress database user password>
dbhost: <database host>
dbuser: <wordpress database user>
wpdb: <wordpress database name>
```
* Configure aws cli, use access key and secret key

```console
aws configure
```
* Run terraform

```
terraform init
terraform apply --var-file vars.tfvars
```