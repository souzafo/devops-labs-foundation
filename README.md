# Lab 04: Shift-Left Security (Gitleaks, Semgrep & Trivy)

Este laboratório demonstra a implementação prática da estratégia **Shift-Left Security**, integrando ferramentas de análise automatizada de código, segredos e infraestrutura tanto no ambiente de desenvolvimento local quanto na pipeline de CI/CD via GitHub Actions.

---

## 🛠️ Pilares e Ferramentas

1. **Gitleaks (Secret Detection):** Varredura preventiva para evitar o commit e push de credenciais, chaves de API e tokens hardcoded.
2. **Semgrep (SAST - Análise Estática):** Detecção de más práticas, falhas lógicas e vulnerabilidades de código-fonte (ex: *Command Injection* via `shell=True`).
3. **Trivy (Container & IaC Security):** Análise de vulnerabilidades (CVEs) em imagens base de containers e más configurações de segurança em Dockerfiles e manifestos de IaC.

---

## 🚀 Como Executar Localmente

### 1. Detecção de Segredos com Gitleaks
Para validar ficheiros na área de staging (`git add`):
```bash
git add src/app.py
gitleaks protect --staged -v
```

### 2. Análise Estática de Código com Semgrep
Analisando vulnerabilidades no código-fonte Python localmente:
```bash
docker run --rm -v $(pwd):/src returntocorp/semgrep semgrep --config=auto /src
```

### 3. Análise de Segurança em Dockerfile com Trivy
Análise de boas práticas de IaC no Dockerfile:
```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/root/.cache/ aquasec/trivy:latest config .
```

Análise de vulnerabilidades (CVEs) na imagem base:
```bash
docker run --rm aquasec/trivy:latest image python:3.11-alpine
```

---

## 🤖 Automação em CI/CD (GitHub Actions)

A pipeline automatizada em `.github/workflows/shift-left-security.yml` executa as seguintes verificações a cada `push` ou `pull_request`:

- **Gitleaks Action:** Interrompe a build caso seja detetado algum segredo no histórico ou alterações do commit.
- **Semgrep CLI:** Executa análise estática de código no repositório.
- **Trivy Action:** Escaneia o diretório `labs/04-shift-left-security` para garantir conformidade do Dockerfile e ausência de severidades `HIGH` ou `CRITICAL`.

---

## 💡 Aprendizados de Engenharia & SRE

- **Defense in Depth:** A segurança deve ser aplicada em múltiplas camadas — desde o pre-commit hook (máquina do desenvolvedor) até ao gating no PR (CI/CD) e registry/cluster.
- **Feedback Loop Rápido:** Identificar e bloquear erros de credenciais e más configurações de containers na fase de desenvolvimento minimiza o impacto em produção e reduz drasticamente o custo de remediação.
- **Princípio do Menor Privilégio:** Atualização de imagens base obsoletas para Alpine/Distroless, execução de containers com utilizadores não-root e isolamento de variáveis sensíveis via ambiente.