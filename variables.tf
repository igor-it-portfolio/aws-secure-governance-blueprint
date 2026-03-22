variable "aws_region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto de governança"
  type        = string
  default     = "arquivo-central-digital"
}

# Aqui está a mágica: definimos os níveis de acesso
variable "archive_roles" {
  description = "Cargos do Arquivo Central"
  type        = list(string)
  default     = ["gerente", "auxiliar", "estagiario"]
}

variable "my_public_ip" {
  description = "Meu IP público para acesso administrativo"
  type        = string
  # O /32 diz ao AWS: "Apenas este computador e nenhum outro".
  default     = "45.184.202.16/32" 
}