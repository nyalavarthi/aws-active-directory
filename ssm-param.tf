
resource "random_string" "password" {
  length           = 12
  special          = true
  upper            = true
  override_special = "_!$"
}
#Create password for Active Directory and save in parameter store
resource "aws_ssm_parameter" "secret" {
  name        = "/${local.environment}/directory/password/master"
  description = "Active Directory master password"
  type        = "SecureString"
  value       = random_string.password.result

  tags = {
    Name        = "${var.tag_prefix}-${local.environment}-AD-SSM-Param"
    environment = local.environment
  }
}

