provider "aws" {
  region = "us-west-2"  # Change this to your desired region
  access_key = "YOUR_ACCESS_KEY"
  secret_key = "YOUR_SECRET_KEY"
}
provider "aws" {
  region = "us-west-2"  # Change this to your desired region
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "my-keypair"  # Replace with your key pair name

  tags = {
    Name = "example-instance"
  }
}
