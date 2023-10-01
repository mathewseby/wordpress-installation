resource "aws_iam_role" "admin" {
  name = "admin"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : aws_iam_role.bastion-role.arn,
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "bastion-role" {
  name = "bastionrole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "bastionpolicy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "sts:GetSessionToken",
            "sts:DecodeAuthorizationMessage",
            "sts:GetAccessKeyInfo",
            "sts:GetCallerIdentity",
            "sts:GetServiceBearerToken"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : "sts:*",
          "Resource" : [
            "arn:aws:iam::279601183831:user/*",
            "arn:aws:iam::279601183831:role/*"
          ]
        }
      ]
    })
  }
}

resource "aws_iam_instance_profile" "bastion-profile1" {
  name = "bastion-instance-profile1"
  role = aws_iam_role.bastion-role.name

}

