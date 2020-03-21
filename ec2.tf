#Security group for windows instance.

resource "aws_security_group" "allow_rds" {
  name        = "${local.tag_prefix}-${local.environment}-TEST-AD-SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 3389
    to_port     = 3389
    protocol    = 6
    description = "RDP access to Windows"
    cidr_blocks = [local.sg_cidr_ingress]
  }

  tags = {
    Name        = "${local.tag_prefix}-${local.environment}-AD-SG"
    Environment = local.environment
  }
}

resource "aws_iam_role" "role" {
  name = "dev-ec2-ad-domain-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
}
EOF
  tags = {
    Name        = "${local.tag_prefix}-${local.environment}-AD-Role"
    Environment = local.environment
  }
}

#these permissions are requred for the the SSM Instance profile for the EC2 domain join to work.
resource "aws_iam_role_policy_attachment" "policy-attach1" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
resource "aws_iam_role_policy_attachment" "policy-attach2" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "policy-attach3" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}

resource "aws_iam_instance_profile" "ad_profile" {
  name = "test_ec2_ad_profile"
  role = aws_iam_role.role.name
}


#create EC2 WIndows Instance
resource "aws_instance" "MSFT-AD-Instance" {
  ami           = local.ami_id
  instance_type = local.ec2_instance_type
  subnet_id            = local.private_subnet1
  iam_instance_profile = aws_iam_instance_profile.ad_profile.name
  vpc_security_group_ids = [aws_security_group.allow_rds.id]
  key_name               = local.ec2_key_pair_name
  tags = {
    Name        = "DEV-AD-Join"
    Environment = local.environment,
  }
}

# Associate SSM document to EC2 instance.
resource "aws_ssm_association" "associate_DEV_MSFT-AD-Instance-domain" {
  name        = local.dns_name
  instance_id = aws_instance.MSFT-AD-Instance.id
}
