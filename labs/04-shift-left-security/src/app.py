import os
import subprocess

# Boa prática: Ler credenciais estritamente através de variáveis de ambiente
AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID", "default_value_if_not_set")
AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY", "default_value_if_not_set")

def execute_user_input(user_command):
    # Boa prática: Utilizar shell=False e passar argumentos em lista para prevenir Command Injection
    # Exemplo seguro com comando estático
    subprocess.run(["echo", "Executando comando de forma segura..."], shell=False)

if __name__ == "__main__":
    execute_user_input("test")