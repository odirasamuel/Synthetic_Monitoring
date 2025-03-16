output "replicate_key_name" {
  description = "Name of the key pair (if created)."
  value       = length(aws_key_pair.replicate_key) > 0 ? aws_key_pair.replicate_key[0].key_name : null
}

output "replicate_key_id" {
  description = "ID of the key pair (if created)."
  value       = length(aws_key_pair.replicate_key) > 0 ? aws_key_pair.replicate_key[0].id : null
}