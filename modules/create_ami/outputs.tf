output "ami_id" {
  value = "${aws_ami_from_instance.ami.ami_id}"
}

output "ami_name" {
  value = "${aws_ami_from_instance.ami.name}"
}