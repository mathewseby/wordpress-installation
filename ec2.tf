resource "aws_instance" "test-instance" {
  ami = "ami-06cf02a98a61f9f5e"
  subnet_id = aws_subnet.ec2-01.id
  vpc_security_group_ids = [
    "${aws_security_group.ec2_sg.id}"
  ]
  instance_type = "t2.micro"
  key_name = "test-instance-key"

  provisioner "remote-exec" {
    inline = ["echo Wait until SSH is ready"]

    connection {
      type = "ssh"
      user = "centos"
      private_key = file(local.private_key_path)
      host = "${aws_instance.test-instance.public_ip}"
    }

  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.test-instance.public_ip}, --private-key ${local.private_key_path} playbooks/roles/wordpress/tasks/main.yml"
  }
}

output "ec2_public-ip" {
  value = "${aws_instance.test-instance.public_ip}"
}