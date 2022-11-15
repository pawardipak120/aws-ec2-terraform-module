resource "tls_private_key" "instance" {
  count = var.create_ec2_key_pair ? 1 : 0
  algorithm = "RSA"
}

resource "aws_key_pair" "instance" {
  count = var.create_ec2_key_pair ? 1 : 0
  key_name   = "${var.name}-ec2-ssh-key"
  public_key = tls_private_key.instance[0].public_key_openssh
  tags = merge({Name = "${var.name}-ec2-ssh-key"}, var.tags)
}

resource "aws_secretsmanager_secret" "example" {
  count = var.create_ec2_key_pair ? 1 : 0
  name = "${var.name}-ec2-instance-private-key"
}

resource "aws_secretsmanager_secret_version" "example" {
  count = var.create_ec2_key_pair ? 1 : 0
  secret_id     = aws_secretsmanager_secret.example[0].id
  secret_string = tls_private_key.instance[0].private_key_pem
}

