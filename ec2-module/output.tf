output "id" {
  description = "The ID of the instance"
  value       = try(aws_instance.this[0].id, "")
}
output "arn" {
  description = "The ARN of the instance"
  value       = try(aws_instance.this[0].arn, "")
}

output "instance_state" {
  description = "The state of the instance. One of: `pending`, `running`, `shutting-down`, `terminated`, `stopping`, `stopped`"
  value       = try(aws_instance.this[0].instance_state ,"")
}

output "primary_network_interface_id" {
  description = "The ID of the instance's primary network interface"
  value       = try(aws_instance.this[0].primary_network_interface_id,"")
}

output "private_dns" {
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = try(aws_instance.this[0].private_dns,"")
}

output "public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = try(aws_instance.this[0].public_dns, "")
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = try(aws_instance.this[0].public_ip, "")
}

output "private_ip" {
  description = "The private IP address assigned to the instance."
  value       = try(aws_instance.this[0].private_ip, "")
}

## EC2 IAM Role Policy

output "ec2_iam_role_name" {
  value = try(aws_iam_role.main[0].name, "")
}

# Ec2 ssh key

output "secretsmanager_secret" {
  value = try(aws_secretsmanager_secret.example.id, "")
}

output "secretsmanager_secret_version" {
  value = try(aws_secretsmanager_secret_version.example.id,"")
}

output "ssh_keyname" {
  value = try(aws_key_pair.instance.key_name,"")
}

output "ssh_private_key" {
  value = try(tls_private_key.instance.private_key_pem,"")
}