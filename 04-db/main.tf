# creating MYSQL database using RDS opensource module
module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.project_name}-${var.environment}"

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name  = "transactions" #default schema for expense project
  username = "root"
  port     = "3306"

  vpc_security_group_ids = [data.aws_ssm_parameter.db_sg_id.value]

  # db subnet group name
  db_subnet_group_name = data.aws_ssm_parameter.db_subnet_group_name.value

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  manage_master_user_password = false
  password = "ExpenseApp1"
  skip_final_snapshot = true

  tags = merge(
    var.comman_tags,
    {
        Name = "${var.project_name}-${var.environment}"
    }
  )

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
# creating R53 record for rds endpoint
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    { 
      name = "db-${var.environment}" # db-dev.goadd.fun
      type    = "CNAME" # as it is pointing to another domain in rds endpoint
      ttl     = 1
      allow_overwrite = true
      records = [
        module.db.db_instance_address
      ]
    }
  ]
}