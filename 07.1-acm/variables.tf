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
    component = "acm"
  }
}
variable "zone_id" {
  default = "Z0886179189CALGJIR20N"
}

variable "zone_name" {
  default = "goadd.fun"
}