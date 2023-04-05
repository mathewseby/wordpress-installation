//resource "aws_efs_file_system" "wp-efs" {
//  count          = var.install_type == "ecs" ? 1 : 0
//  creation_token = "wp-efs"
//  encrypted      = "true"
//}
//
//resource "aws_efs_access_point" "wp-efs-ap" {
//  count          = var.install_type == "ecs" ? 1 : 0
//  file_system_id = aws_efs_file_system.wp-efs.id
//}
//
//resource "aws_efs_mount_target" "wp-efs-mp" {
//  count          = var.install_type == "ecs" ? 1 : 0
//  file_system_id = aws_efs_file_system.wp-efs.id
//  subnet_id      = one(aws_subnet.efs-01[*].id)
//  security_groups = ["${one(aws_security_group.efs-sg[*].id)}"
//  ]
//}
