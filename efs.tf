resource "aws_efs_file_system" "wp-efs" {
  creation_token = "wp-efs"
}

resource "aws_efs_access_point" "wp-efs-ap" {
  file_system_id = aws_efs_file_system.wp-efs.id
}

resource "aws_efs_mount_target" "wp-efs-mp" {
  file_system_id = aws_efs_file_system.wp-efs.id
  subnet_id      = one(aws_subnet.efs-01[*].id)
  security_groups = ["${one(aws_security_group.efs-sg[*].id)}"
  ]
}
