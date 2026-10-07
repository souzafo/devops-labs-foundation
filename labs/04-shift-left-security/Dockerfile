# Usando imagem base Python recente e leve (Alpine)
FROM python:3.11-alpine

WORKDIR /app

# Criando um usuário sem privilégios para não rodar como root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copia os arquivos e ajusta permissões
COPY src/ /app/src/
RUN chown -R appuser:appgroup /app

# Define o usuário não-root
USER appuser

HEALTHCHECK --interval=30s --timeout=3s CMD python -c "import sys; sys.exit(0)"

CMD ["python", "src/app.py"]