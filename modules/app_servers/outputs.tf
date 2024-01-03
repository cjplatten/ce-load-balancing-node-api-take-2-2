output "instance_ids" {
  description = "list of EC2 instance ids"
  value = aws_instance.ec2[*].id
}