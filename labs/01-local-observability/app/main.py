import time
from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI(
    title="DevOps Foundation App",
    description="API para testes de observabilidade local e nuvem",
    version="1.0.0"
)

# Instrumentação automática de métricas Prometheus
Instrumentator().instrument(app).expose(app)

@app.get("/")
def read_root():
    return {"status": "ok", "message": "DevOps Labs API em execução!"}

@app.get("/healthz")
def health_check():
    return {"status": "healthy"}

@app.get("/slow-endpoint")
def slow_endpoint():
    # Simula um processamento mais lento para vermos a métrica de latência variar no Grafana
    time.sleep(0.5)
    return {"message": "Processamento concluído com delay simulado"}