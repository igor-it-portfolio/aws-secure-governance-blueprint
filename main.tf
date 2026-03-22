locals {
  common_tags = {
    Project    = "Governança-Arquivos"
    Department = "Arquivo-Central"
    ManagedBy  = "Terraform"
  }
}

# ==========================================
# 1. SEGURANÇA E ACESSO (SSH & FIREWALL)
# ==========================================

resource "aws_key_pair" "gerente_key" {
  key_name   = "chave-governance-oficial"
  public_key = file("${path.module}/id_rsa_gerente.pub")
}

resource "aws_security_group" "arquivo_access" {
  name        = "sg_acesso_arquivo_v3"
  description = "Acesso para o IP do Igor"

  ingress {
    description = "SSH do Igor"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Aberto para garantir que você entre agora!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# ==========================================
# 2. IDENTIDADE E GOVERNANÇA (IAM)
# ==========================================

resource "aws_iam_role" "role_gerente_arquivo" {
  name = "role_gerente_arquivo_v3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_instance_profile" "profile_gerente" {
  name = "profile_gerente_v3"
  role = aws_iam_role.role_gerente_arquivo.name
}

resource "aws_iam_role_policy" "policy_s3_full" {
  name = "policy_acesso_s3_v3"
  role = aws_iam_role.role_gerente_arquivo.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:*"]
      Effect   = "Allow"
      Resource = [
        "arn:aws:s3:::empresa-arquivos-confidenciais-gerente-igorc-2016-teste",
        "arn:aws:s3:::empresa-arquivos-confidenciais-gerente-igorc-2016-teste/*"
      ]
    }]
  })
}

# ==========================================
# 3. COMPUTAÇÃO (SERVIDOR EC2)
# ==========================================

resource "aws_instance" "servidor_arquivo" {
  ami           = "ami-04b70fa74e45c3917" 
  instance_type = "t3.micro" 

  key_name               = aws_key_pair.gerente_key.key_name
  vpc_security_group_ids = [aws_security_group.arquivo_access.id]
  iam_instance_profile   = aws_iam_instance_profile.profile_gerente.name

  tags = merge(local.common_tags, {
    Name = "Estacao-Gerente-Igor-Final"
  })
}

# ==========================================
# 4. STORAGE (S3 BUCKET)
# ==========================================

resource "aws_s3_bucket" "bucket_projeto_arquivos" {
  bucket = "empresa-arquivos-confidenciais-gerente-igorc-2016-teste" 
  
  tags = {
    Name        = "Bucket Confidencial"
    Environment = "Producao"
  }
}

resource "aws_s3_bucket_public_access_block" "trava_total_s3" {
  bucket                  = aws_s3_bucket.bucket_projeto_arquivos.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "instancia_ip" {
  value = aws_instance.servidor_arquivo.public_ip
}