data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

# data "aws_ssm_parameter" "db_sg_id" {
#   name = "/${var.project_name}/${var.environment}/db_sg_id"
# }

# data "aws_ssm_parameter" "backend_sg_id" {
#   name = "/${var.project_name}/${var.environment}/backend_sg_id"
# }

# data "aws_ssm_parameter" "frontend_sg_id" {
#   name = "/${var.project_name}/${var.environment}/frontend_sg_id"
# }