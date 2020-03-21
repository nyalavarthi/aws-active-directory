#Creare MSFT AD.
resource "aws_directory_service_directory" "SampleAD-NY" {
  name       = local.dns_name
  password   = random_string.password.result
  edition    = "Standard"
  type       = "MicrosoftAD"
  short_name = local.dns_short_name

  vpc_settings {
    vpc_id     = local.vpc_id
    subnet_ids = [local.private_subnet1, local.private_subnet2]
  }

  tags = {
    Name        = "${var.tag_prefix}-${local.environment}-Microsoft-AD"
    environment = local.environment
    "app:name"  = "Core Infra"
  }
}

#Create SSM document, one time activity per AD
resource "aws_ssm_document" "ssm_document_3" {
  name          = local.dns_name
  document_type = "Command"
  depends_on    = [aws_directory_service_directory.SampleAD-NY]
  content       = <<DOC
{
    "schemaVersion": "1.0",
    "description": "Automatic Domain Join Configuration",
    "runtimeConfig": {
        "aws:domainJoin": {
            "properties": {
                "directoryId": "${aws_directory_service_directory.SampleAD-NY.id}",
                "directoryName": "${local.dns_name}",
                "dnsIpAddresses": [
                     "${sort(aws_directory_service_directory.SampleAD-NY.dns_ip_addresses)[0]}",
                     "${sort(aws_directory_service_directory.SampleAD-NY.dns_ip_addresses)[1]}"
                  ]
            }
        }
    }
}
DOC

  tags = {
    Name        = "${var.tag_prefix}-${local.environment}-SSM-Document"
    environment = local.environment
    "app:name"  = "Core Infra"
  }
}
