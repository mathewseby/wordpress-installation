# Create AWS Instance with Terraform and provision Wordpress using Ansible

This is a simple project which creates AWS infrastructure (VPC, subnets, ec2 instance, security group) using terraform 
and provision wordpress in the instance using ansible, after running `terraform apply` you can directly access the installation page of
wordpress from web browser. The ansible role will be run directly after infrastructure creation by terraform. There project consist of following ways to create server and 
run Wordpress in it.

* Create EC2 and Install LAMP and Wordpress in server.
* Create EC2 and use Docker to run MySQL and Wordpress in server.
* Create EC2, RDS and install Wordpress in EC2 and use RDS for MySQL.
* Create EC2, RDS and install Wordpress in docker container and use RDS for MySQL.

Note: 
* Database used for the wordpress is mariadb in this setup.
* Ansible role supports both centos and amazon-linux 2

## How to run

### Prerequisites

* [Terraform](https://www.terraform.io/downloads.html)
* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* Disable strict host key checking in ansible config (change `host_key_checking = False` in ansible.cfg)

### Preperation

* Create and download ssh key from AWS
* Clone the git repository

```console
git clone https://github.com/mathewseby/wordpress.git
```

### Step to run

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

Update following variables to change installation method in [vars.tfvars](./vars.tfvars)

* Create EC2 and Install LAMP and Wordpress in server.
```
install_type        = "server"  
```
* Create EC2 and use Docker to run MySQL and Wordpress in server.
```
install_type        = "docker" 
```
* Create EC2, RDS and install Wordpress in EC2 and use RDS for MySQL.
```
install_type        = "server_with_rds" 
```
* Create EC2, RDS and install Wordpress in EC2 and use RDS for MySQL.
```
install_type        = "with_docker_rds" 
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