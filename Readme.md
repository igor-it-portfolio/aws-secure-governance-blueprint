# 🛡️ AWS Cloud Governance: Central de Arquivos Confidenciais
> **Projeto Estratégico:** - Implementação do Core Administrativo (Gerente)
> **Compliance Status:** 🟢 High Security (Zero Trust Architecture)

![Terraform](https://img.shields.io/badge/Terraform-1.x-5835CC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Infrastructure-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Security](https://img.shields.io/badge/Security-Audit_Passed-success?style=for-the-badge)
![Linux](https://img.shields.io/badge/Ubuntu-24.04_LTS-E9431E?style=for-the-badge&logo=ubuntu&logoColor=white)

## 📖 Visão Executiva do Sistema
Este repositório estabelece a fundação de um **Sistema de Governança de Arquivos Digitais**. O objetivo central é gerenciar documentos sigilosos da empresa através de uma arquitetura de nuvem que elimina o uso de chaves de acesso estáticas, utilizando identidades federadas (**IAM Roles**) para garantir o **Princípio do Menor Privilégio**.

A solução automatiza a criação de uma **Estação de Gerência** isolada, protegida por criptografia assimétrica, que serve como o único ponto de entrada para o bucket de arquivos confidenciais.

---

## 👥 Roadmap de Hierarquia de Acesso
O projeto foi desenhado para ser escalável, suportando a futura implementação de múltiplos níveis de permissão:

| Nível de Acesso | Cargo | Permissões (IAM Policy) | Status |
| :--- | :--- | :--- | :--- |
| **Nível 1** | **Gerente (Igor C.)** | Full Access (CRUD) + Gestão de Políticas de Retenção. | **Ativo** |
| **Nível 2** | **Auxiliares** | Read/Write em pastas específicas (Upload/Consulta). | *Pendente* |
| **Nível 3** | **Estagiários** | Read-Only (Consulta de Documentos de Treinamento). | *Pendente* |

---

## 🏗️ Arquitetura Técnica do Arquivo Central
A infraestrutura foi provisionada seguindo o framework de Well-Architected da AWS:

| Componente | Tecnologia | Função de Governança |
| :--- | :--- | :--- |
| **Compute** | EC2 (Ubuntu 24.04 LTS) | Estação de Gerência dedicada para operações do Gerente. |
| **Identity** | IAM Role `role_gerente_v3` | Autenticação via STS (Zero Access Keys em disco). |
| **Storage** | Amazon S3 | Bucket: `empresa-arquivos-confidenciais-gerente-igorc-2016-teste`. |
| **Access** | SSH RSA 4096-bit | Criptografia de alta resistência (Superando o padrão 2048). |
| **Network** | Security Groups | Firewall *Stateful* restringindo o tráfego administrativo. |



---

## 🔒 Camadas de Segurança & Hardening

### 1. Governança de Identidade (Zero Trust)
Diferente de abordagens tradicionais, a estação do gerente **não armazena credenciais**. Ela utiliza um `aws_iam_instance_profile`, permitindo que o AWS CLI assuma uma Role temporária com permissões granulares apenas para o bucket administrativo.

### 2. Hardening do S3 (Arquivos Confidenciais)
O bucket S3 implementa a camada `aws_s3_bucket_public_access_block`, garantindo:
- [x] **Block Public ACLs:** Impede exposição via listas de controle.
- [x] **Block Public Policy:** Rejeita qualquer política que permita acesso externo.
- [x] **Force Destroy Protection:** Proteção contra deleção acidental de dados críticos.

---

## 🛠️ Guia de Deploy & Validação Administrativa

### Passo a Passo
1. **Inicializar o Terraform:** `terraform init`
2. **Provisionar Infraestrutura:** `terraform apply -auto-approve`
3. **Validação de Identidade (Dentro da EC2):**
   ```bash
   # Confirma que o Gerente está operando sob a Role correta
   aws sts get-caller-identity

   ## 📂 Estrutura do Projeto (Versionamento Seguro)

Para garantir que o "segredo" do projeto não vaze, o arquivo `.gitignore` protege:

* **id_rsa_gerente:** Chave privada do Gerente (Omitida).
* **terraform.tfstate:** Estado sensível da infraestrutura (Omitido).
* **.terraform/:** Binários e plugins do provedor (Omitido).

## 📊 Evidências Técnicas

Resultados da fase de homologação:

* **SSH Handshake:** Validado com sucesso via RSA-4096.
* **IAM STS Token:** Gerado e validado em menos de 0.5s.
* **S3 Integrity:** Upload e listagem de arquivos confidenciais confirmados via túnel seguro.

---
**Igor Pantoja** | *Cloud Infrastructure & Cybersecurity Specialist*