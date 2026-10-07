# Usando uma imagem base deliberadamente antiga do Python para identificar CVEs conhecidas
FROM python:3.8-slim-buster

WORKDIR /app

# Copia nosso código
COPY src/ /app/src/

CMD ["python", "src/app.py"]