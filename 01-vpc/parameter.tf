resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  # it will store the output of vpc_id given in terraform-aws-vpc with above name
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/public_subnet_ids"
  # parameter store format is id1,id2
  #but we r giving list [id1,id2], so convert it into stringlist
  type  = "StringList"
  # it will store the output of public_subnet_ids given in terraform-aws-vpc with above name
  value = join(",", module.vpc.public_subnet_ids)
}
resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/private_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.private_subnet_ids)
}
resource "aws_ssm_parameter" "db_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/db_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.db_subnet_ids)
}

resource "aws_ssm_parameter" "db_subnet_group_name" {
  name  = "/${var.project_name}/${var.environment}/db_subnet_group_name"
  type  = "String"
  value = module.vpc.db_subnet_group_name
}