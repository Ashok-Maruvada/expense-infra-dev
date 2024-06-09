module "database_sg" {
  source = "../../terraform-aws-securitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for DB MySQL instances"
  common_tags = var.comman_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "db"
}
module "backend_sg" {
  source = "../../terraform-aws-securitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for backend instances"
  common_tags = var.comman_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "backend"
}
module "app_alb_sg" {
  source = "../../terraform-aws-securitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for app alb"
  common_tags = var.comman_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "app_alb"
}
module "frontend_sg" {
  source = "../../terraform-aws-securitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for frontend instances"
  common_tags = var.comman_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "frontend"
}
module "web_alb_sg" {
  source = "../../terraform-aws-securitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for web alb"
  common_tags = var.comman_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "web_alb"
}
module "bastion_sg" {
  source = "../../terraform-aws-securitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for bastion instance"
  common_tags = var.comman_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "bastion"
}
module "vpn_sg" {
  source = "../../terraform-aws-securitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for vpn"
  common_tags = var.comman_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "vpn"
  inbound_rules = var.vpn_sg_rules
}
#below are all ingress rules for the above security groups
# DB is allowing traffic from Backend
resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  #source security group id is nothing but from where you are getting traffic
  #source_security_group_id = data.aws_ssm_parameter.backend_sg_id.value
  #without data source , y can get the sg id as below
  source_security_group_id = module.backend_sg.sg_id
  #security_group_id = data.aws_ssm_parameter.db_sg_id.value
  security_group_id = module.database_sg.sg_id
}
# DB is allowing traffic from Bastion
resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  #source security group id is nothing but from where you are getting traffic
  #source_security_group_id = data.aws_ssm_parameter.backend_sg_id.value
  #without data source , y can get the sg id as below
  source_security_group_id = module.bastion_sg.sg_id
  #security_group_id = data.aws_ssm_parameter.db_sg_id.value
  security_group_id = module.database_sg.sg_id
}
# DB is allowing traffic from vpn
resource "aws_security_group_rule" "db_vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  #security_group_id = data.aws_ssm_parameter.db_sg_id.value
  security_group_id = module.database_sg.sg_id
}
# backend is allowing traffic from bastion
resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.backend_sg.sg_id
}
# backend is allowing traffic from app alb
resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.sg_id
  security_group_id = module.backend_sg.sg_id
}
# backend is allowing traffic from vpn ssh
resource "aws_security_group_rule" "backend_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.backend_sg.sg_id
}
# backend is allowing traffic from vpn http
resource "aws_security_group_rule" "backend_vpn_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.backend_sg.sg_id
}

# frontend is allowing traffic from web alb
resource "aws_security_group_rule" "frontend_web_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb_sg.sg_id
  #security_group_id = data.aws_ssm_parameter.frontend_sg_id.value
  security_group_id = module.frontend_sg.sg_id
}
# frontend is allowing traffic from bastion
resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  #security_group_id = data.aws_ssm_parameter.frontend_sg_id.value
  security_group_id = module.frontend_sg.sg_id
}
# frontend is allowing traffic from vpn
resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  #security_group_id = data.aws_ssm_parameter.frontend_sg_id.value
  security_group_id = module.frontend_sg.sg_id
}
# this ingress rule is needed when not using VPN connection - to connect frontend server via ssh to configure
# frontend is allowing traffic from public but its not safe as public can access it and may cause hacking
# not required, as we are using VPN connection
# resource "aws_security_group_rule" "frontend_public" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
#   #security_group_id = data.aws_ssm_parameter.frontend_sg_id.value
#   security_group_id = module.frontend_sg.sg_id
# }
# app alb is allowing traffic from frontend
resource "aws_security_group_rule" "app_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}
# app alb is allowing traffic from bastion
resource "aws_security_group_rule" "app_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}
# app alb is allowing traffic from vpn
resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}
# web alb is allowing traffic from public via http
resource "aws_security_group_rule" "web_alb_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.sg_id
}
# web alb is allowing traffic from public via https
resource "aws_security_group_rule" "web_alb_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.sg_id
}
# bastion is allowing traffic from internet/public
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.sg_id
}