instance_key_name   = "wp-test"
ssh-user            = "ec2-user"
private_key_path    = "/home/mathew/Downloads/wp-testkey.pem"
instance-type       = "t3.micro"
instance-ami        = "ami-0a23ccb2cdd9286bb"
region              = "ap-south-1"
install_type        = "eks" #server,server_with_rds,with_docker_rds,docker,ecs
mysql_root_password = "12345678"