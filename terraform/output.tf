# Output the public IP of the EC2 instance
output "ec2_public_ip" {
  value = aws_instance.rails_server.public_ip
}

# Output the Elastic IP address
output "elastic_ip" {
  value       = aws_eip.rails_eip.public_ip
  description = "The Elastic IP address assigned to the EC2 instance"
} 