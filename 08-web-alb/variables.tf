variable "project_name" {
  default = "expense"
}
variable "environment" {
  default = "dev"
}
variable "comman_tags" {
  type = map
  default = {
    Project = "expense"
    Environment = "dev"
    Terraform = "true"
    component = "web-alb"
  }
}

variable "zone_name" {
  default = "goadd.fun"
}