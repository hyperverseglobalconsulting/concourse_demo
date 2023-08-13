resource "aws_ebs_volume" "concourse_volumes" {
  count             = 3
  availability_zone = "us-east-2a" # Adjust this to your desired zone
  size              = 20 # Size in GiB
  type              = "gp2"

  tags = {
    Name = "concourse_volume-${count.index}"
  }
}

output "ebs_volume_ids" {
  value = aws_ebs_volume.concourse_volumes[*].id
  description = "EBS Volume IDs for Concourse"
}
