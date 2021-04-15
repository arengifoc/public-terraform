provider "aws" {
  region = "us-west-2"
}

module "ec2" {
  source = "/mnt/z/git/splunk/dvo/modules/terraform-module-aws-ec2/modules/ec2"

  instance_count = 1
  ami            = "ami-06bbfb353151c9fc9"
  instance_type  = "t3a.small"

  # VPC attributes.
  vpc_id               = "vpc-xxxxxxxx"
  instance_subnet_list = ["subnet-xxxxxxxx"]

  root_block_device = [
    {
      volume_size = "20"
      volume_type = "gp2"
    }
  ]

  # EBS volume attributes.
  create_ebs_volumes = false
  # ebs_volume_name          = var.ebs_volume_name
  # ebs_volume_type          = var.ebs_volume_type          # Default = ["gp2"]
  # ebs_volume_size          = var.ebs_volume_size          # Default = ["50"]
  # ebs_volume_iops          = var.ebs_volume_iops          # Default = ["0"]
  # ebs_volume_device_name   = var.ebs_volume_device_name   # Default = ["/dev/sdh"]
  enable_volume_encryption = true

  # Instance profile attributes.
  # attach_instance_profile          = var.attach_instance_profile          # Default = true
  # attach_existing_instance_profile = var.attach_existing_instance_profile # Default = false
  # existing_instance_profile_name   = var.existing_instance_profile_name   # Default = ""
  # create_instance_profile          = var.create_instance_profile          # Default = true
  # new_instance_profile_name        = var.new_instance_profile_name

  # EC2 custom attributes.
  key_name = "id_sbx_test"
  # associate_public_ip_address          = var.associate_public_ip_address # Default = false
  # enable_detailed_monitoring           = false
  # ebs_optimized                        = false
  # source_dest_check                    = true
  # enable_ec2_termination_protection    = var.enable_ec2_termination_protection # Default = true
  # instance_initiated_shutdown_behavior = "stop"

  # Security group attributes.
  create_security_group = true

  attach_existing_sg = false
  existing_sg_ids    = []

  enable_security_group_ids_ingress = false
  security_group_ids_ingress        = []

  # enable_security_group_cidr_ingress = var.enable_security_group_cidr_ingress # Default = true
  security_group_cidr_ingress = ["10.0.0.0/8"]
  allowed_ports               = ["22"]
  protocol                    = ["tcp"]

  user_data_list = [""]

  # tags = var.tags
}
