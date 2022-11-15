resource "aws_iam_role" "main" {
  count = var.create_ec2_profile ? 1 : 0
  name        = "${var.name}-ec2-role"
  path        = "/"
  description = "IAM Role for ec2 for ${var.name}"
  assume_role_policy    = templatefile("${path.module}/ec2_assume_policy.json",{})
  force_detach_policies = true
  tags = merge({ "name" = "${var.name}-ec2-role" }, var.tags)
}

resource "aws_iam_instance_profile" "ec2_profile" {
  count = var.create_ec2_profile ? 1 : 0
  name = "${var.name}-ec2-profile"
  role = aws_iam_role.main[0].name
}

resource "aws_iam_policy_attachment" "ec2_ssm_role_policy" {
  count = var.create_ec2_profile && var.create_ssm_access ? 1 : 0
  name = "${var.name}-AmazonEC2RoleforSSM-Policy"
  roles      = [aws_iam_role.main[0].name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

