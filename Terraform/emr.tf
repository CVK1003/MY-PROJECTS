# Define provider
provider "aws" {
  region = "us-east-1" # Change to your desired region
}

# Create EMR cluster
resource "aws_emr_cluster" "my_cluster" {
  name          = "my-emr-cluster"
  release_label = "emr-6.4.0" # Change to your desired EMR version
  applications  = ["Spark", "Hive", "Hue"]

  ec2_attributes {
    instance_profile = "EMR_EC2_DefaultRole"  # Change to your instance profile
    key_name         = "my-keypair"           # Change to your key pair
    subnet_id        = "subnet-12345678"       # Change to your subnet ID
    instance_type    = "m5.xlarge"             # Change to your desired instance type
    emr_managed_master_security_group = "sg-12345678" # Change to your EMR managed security group
    emr_managed_slave_security_group  = "sg-12345678" # Change to your EMR managed security group
  }

  service_role = "EMR_DefaultRole" # Change to your service role

  # Additional configurations (optional)
  configurations = <<EOF
  [
    {
      "Classification": "spark",
      "Properties": {
        "maximizeResourceAllocation": "true"
      }
    }
  ]
  EOF

  instances {
    instance_count = 2  # Number of instances in the cluster
    master_instance_type = "m5.xlarge" # Master instance type
    core_instance_type   = "m5.xlarge" # Core instance type
    core_instance_count  = 2            # Number of core instances
  }

  tags = {
    Environment = "Production"
  }
}
