output "copy_ami_id" {
  value = "${aws_ami_copy.copy_ami.ami_id}"
}

output "copy_ami_name" {
  value = "${aws_ami_copy.copy_ami.name}"
}