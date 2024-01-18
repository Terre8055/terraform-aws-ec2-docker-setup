




# Create ssh rsa key pair to connect to instances
resource "aws_key_pair" "key-pair" {
key_name      = "tf-key-pair-mike-${terraform.workspace}"
public_key    = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
algorithm     = "RSA"
rsa_bits      = 4096
}

resource "local_file" "file" {
content       = tls_private_key.rsa.private_key_pem
filename      = "tf-key-pair-${terraform.workspace}"
}

#Move the key pair to the .ssh home directory
resource "null_resource" "move_key_to_ssh_directory" {
  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ~/.ssh
      mv ${local_file.file.filename} ~/.ssh/${aws_key_pair.key-pair.key_name}
      chmod 600 ~/.ssh/${aws_key_pair.key-pair.key_name}
    EOT
  }
}




