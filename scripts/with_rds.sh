#!/bin/bash
sed -i 's/.*install_type: .*/   install_type: ${var.install_type}/g' playbooks/install-wordpress.yml ;
sed -i 's/.*rdshost: .*/rdshost: ${one(aws_db_instance.wp-rds[*].endpoint)}/g' playbooks/roles/wordpress/defaults/main.yml ;
sed -i 's/:3306//g' playbooks/roles/wordpress/defaults/main.yml ;
ansible-playbook -i ${aws_instance.wp-instance.public_ip}, -u ${var.ssh-user} playbooks/install-wordpress.yml ;
sleep 30s ;
curl -I ${aws_instance.wp-instance.public_ip}