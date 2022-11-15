resource "tls_private_key" "instance" {
  algorithm = "RSA"
}

resource "aws_key_pair" "instance" {
  key_name   = var.key_name
  public_key = tls_private_key.instance.public_key_openssh
  tags = merge({Name = var.key_name}, var.tags)
}

resource "aws_secretsmanager_secret" "example" {
  name = "${var.key_name}-secret"
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = tls_private_key.instance.private_key_pem
}

output "secretsmanager_secret" {
  value = aws_secretsmanager_secret.example.id
}

output "secretsmanager_secret_version" {
  value = aws_secretsmanager_secret_version.example.id
}

output "ssh_keyname" {
  value = aws_key_pair.instance.key_name
}

output "ssh_private_key" {
  value = tls_private_key.instance.private_key_pem
}
