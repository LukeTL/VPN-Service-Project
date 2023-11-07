# This will contain the compute instances and compute related infrastructure from North Virginia

# Security Groups
# Load Balancers
# Target Group
# Autoscaling group
# Bastion Hosts
# Ansible Control Node - Need to use git clone within to extract playbooks and inventory

# Setup Security groups first, then create dedicated runners to access the bastion hosts
# Bastions will need an EIP

# Setup Bastions in Public subnets
# resource "aws_instance" "us_east_1a_bastion" {
#   provider      = aws.us_provider
#   subnet_id = aws_subnet.us_subnets
#   ami           = data.aws_ami.us_vpn_server_image.id
#   instance_type = "t2.micro"
#   tags = {
#     Type = "vpn_us"
#   }
# }