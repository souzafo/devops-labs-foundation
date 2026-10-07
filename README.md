# Lab 04: Shift-Left Security (Gitleaks, Semgrep & Trivy)

Este laboratorio demonstra a implementacao da estrategia Shift-Left Security, integrando ferramentas de analise automatizada de codigo, segredos e infraestrutura antes da promocao para os ambientes de staging e producao.

## Pilares e Ferramentas

1. Gitleaks (Secret Detection): Varredura de credenciais, chaves de API e tokens hardcoded no codigo ou historico de commits.
2. Semgrep (SAST - Analise Estatica): Deteccao de mas praticas, vulnerabilidades logicas (ex: Command Injection) e desvios de padroes de codigo.
3. Trivy (Container & IaC Security): Varredura de mas configuracoes em Dockerfile e vulnerabilidades conhecidas (CVEs) em imagens e dependencias.

---

## Como Executar Localmente

### 1. Deteccao de Segredos com Gitleaks
Simulando a validacao de arquivos na area de staging (git add):
`git add src/app.py`
`gitleaks protect --staged -v`

### 2. Analise Estatica de Codigo com Semgrep
Analisando vulnerabilidades no codigo-fonte Python:
`docker run --rm -v $(pwd):/src returntocorp/semgrep semgrep --config=auto /src`

### 3. Analise de Seguranca em Dockerfile e CVEs com Trivy
Analise de boas praticas de IaC no Dockerfile:
`docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/root/.cache/ aquasec/trivy:latest config .`

Analise de vulnerabilidades (CVEs) na imagem base:
`docker run --rm aquasec/trivy:latest image python:3.8-slim-buster`

---

## Aprendizados de Engenharia
- Defense in Depth: A seguranca deve atuar no pre-commit hook (maquina do dev), no pull request (CI/CD) e no registry/cluster.
- Prevencao de Drift & Vazamento: Erros de credenciais e ma configuracao de containers devem ser bloqueados no estagio mais barato do ciclo de vida da aplicacao (Shift-Left).