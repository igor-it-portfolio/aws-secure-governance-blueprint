# 🛡️ AWS Cloud Governance & Secure Storage Blueprint
> **Project Phase:** Day 7 - Enterprise Identity & Access Management (IAM)
> **Security Status:** 🟢 High Compliance (Zero Trust Architecture)

![Terraform](https://img.shields.io/badge/Terraform-1.x-5835CC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Infrastructure-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Security](https://img.shields.io/badge/Security-Audit_Passed-success?style=for-the-badge)
![Linux](https://img.shields.io/badge/Ubuntu-24.04_LTS-E9431E?style=for-the-badge&logo=ubuntu&logoColor=white)

## 📖 Visão Executiva
Este repositório contém a infraestrutura automatizada (IaC) para uma **Estação de Trabalho Segura** integrada ao ecossistema de armazenamento confidencial da AWS. O foco central deste blueprint é a **eliminação de vetores de ataque** através da substituição de credenciais estáticas por identidades federadas (**IAM Roles**).

Desenvolvido para garantir que apenas identidades autorizadas e verificadas possam manipular dados sensíveis, seguindo as melhores práticas do *AWS Well-Architected Framework*.

---

## 🏗️ Arquitetura da Solução
A infraestrutura foi desenhada para ser resiliente e auditável:

| Componente | Tecnologia | Função de Governança |
| :--- | :--- | :--- |
| **Compute** | EC2 (Ubuntu 24.04 LTS) | Estação de Gerência isolada para operações críticas. |
| **Identity** | IAM Role & Instance Profile | Autenticação automática via **STS** (Zero Access Keys). |
| **Storage** | Amazon S3 | Bucket: `empresa-arquivos-confidenciais-gerente-igorc-2016-teste`. |
| **Access** | SSH RSA 4096-bit | Criptografia de alta resistência para acesso administrativo. |
| **Network** | Security Groups | Firewall *Stateful* com restrição de tráfego na porta 22. |

---

## 🔒 Camadas de Segurança & Hardening

### 1. Governança de Identidade (IAM)
Diferente de abordagens legadas, esta instância **não armazena credenciais no disco**. Ela utiliza um `aws_iam_instance_profile`, permitindo que o AWS CLI assuma uma Role temporária com permissões granulares de leitura/escrita apenas no bucket de destino.

### 2. Proteção de Dados (S3)
O bucket S3 implementa a camada `aws_s3_bucket_public_access_block`, garantindo:
- [x] **Block Public ACLs:** Impede a exposição via listas de controle de acesso.
- [x] **Block Public Policy:** Rejeita políticas de bucket que permitam acesso externo.
- [x] **Force Destroy Protection:** Segurança contra deleção acidental de dados.

### 3. Criptografia Assimétrica
Utilização de algoritmo **RSA de 4096 bits** para chaves SSH, superando o padrão de mercado (2048), garantindo proteção superior contra ataques de força bruta e computação avançada.

---

## 🛠️ Guia de Deploy & Validação

### Pré-requisitos
- Terraform instalado (v1.x+)
- AWS CLI configurado no ambiente local

### Passo a Passo

**1. Inicializar o Provedor:**
```bash
terraform init

### 3. Validação de Identidade (Dentro da EC2):

```bash
# O comando abaixo deve retornar o ARN da Role, provando a federação de identidade.
aws sts get-caller-identity

📂 Estrutura do Projeto (Versionamento Seguro)
Para manter a segurança do ambiente, o arquivo .gitignore foi configurado para omitir arquivos sensíveis:

id_rsa_gerente: Chave privada (ignorada).

* **terraform.tfstate:** Estado da infraestrutura (ignorado).
* **.terraform/:** Binários do provedor (ignorado).

## 📊 Evidências Técnicas
Durante a fase de homologação (Dia 7), o ambiente foi submetido a testes de estresse e permissão, resultando em:

* **SSH Handshake:** Sucesso via RSA-4096.
* **IAM STS:** Token gerado e validado com sucesso.
* **S3 Integrity:** Upload de arquivos confidenciais via túnel seguro e Role-based access.

---
**Igor Cesar** *Cloud Infrastructure & Cybersecurity Specialist*