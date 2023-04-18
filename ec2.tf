resource "aws_instance" "wp-instance" {
  ami       = var.instance-ami
  subnet_id = aws_subnet.ec2-01.id
  vpc_security_group_ids = [
    "${aws_security_group.ec2_sg.id}"
  ]
  instance_type = var.instance-type
  key_name      = var.instance_key_name
  root_block_device {
    volume_type = "gp3"
  }
  depends_on = [aws_db_instance.wp-rds]

  provisioner "remote-exec" {
    inline = ["echo Wait until SSH is ready"]

    connection {
      type = "ssh"
      user = var.ssh-user
      private_key = file(local.private_key_path)
      host = aws_instance.wp-instance.public_ip
    }

  }

}

resource "null_resource" "rds-server-provision" {
  count = var.install_type == "server_with_rds" || var.install_type == "with_docker_rds" ? 1 : 0
  provisioner "local-exec" {
    command = "sed -i 's/.*install_type: .*/   install_type: ${var.install_type}/g' playbooks/install-wordpress.yml ; sed -i 's/.*mysql_root_password: .*/mysql_root_password: ${var.mysql_root_password}/g' playbooks/roles/wordpress/defaults/main.yml ; sed -i 's/.*rdshost: .*/rdshost: ${one(aws_db_instance.wp-rds[*].endpoint)}/g' playbooks/roles/wordpress/defaults/main.yml ; sed -i 's/:3306//g' playbooks/roles/wordpress/defaults/main.yml ; ansible-playbook -i ${aws_instance.wp-instance.public_ip}, -u ${var.ssh-user} playbooks/install-wordpress.yml ; sleep 30s ; curl -I ${aws_instance.wp-instance.public_ip}"
  }
}

resource "null_resource" "rds-nill-provision" {
  count = var.install_type == "server" || var.install_type == "docker" ? 1 : 0
  provisioner "local-exec" {
    command = "sed -i 's/.*install_type: .*/   install_type: ${var.install_type}/g' playbooks/install-wordpress.yml ; sed -i 's/.*mysql_root_password: .*/mysql_root_password: ${var.mysql_root_password}/g' playbooks/roles/wordpress/defaults/main.yml ; ansible-playbook -i ${aws_instance.wp-instance.public_ip}, -u ${var.ssh-user} playbooks/install-wordpress.yml ; sleep 30s ; curl -I ${aws_instance.wp-instance.public_ip}"
  }
}

output "ec2_public-ip" {
  value = aws_instance.wp-instance.public_ip
}