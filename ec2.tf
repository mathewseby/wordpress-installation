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
      #private_key = file(local.private_key_path)
      host = aws_instance.wp-instance.public_ip
    }

  }
  provisioner "local-exec" {
    command = "sed -i 's/dbhost: localhost/dbhost: ${aws_db_instance.wp-rds.endpoint}/g' playbooks/roles/wordpress/defaults/main.yml ; sed -i 's/3306//g' playbooks/roles/wordpress/defaults/main.yml ; ansible-playbook -i ${aws_instance.wp-instance.public_ip}, -u ${var.ssh-user} playbooks/install-wordpress.yml ; sleep 30s ; curl -I ${aws_instance.wp-instance.public_ip}"
  }
}

output "ec2_public-ip" {
  value = aws_instance.wp-instance.public_ip
}