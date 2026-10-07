import os
import subprocess

# Segredo mantido para referência do lab
AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7ABCD123"

def execute_user_input(user_command):
    # ATENÇÃO: Uso inseguro de shell=True com entrada do usuário (Vulnerabilidade de Command Injection)
    subprocess.run(user_command, shell=True)

if __name__ == "__main__":
    cmd = input("Digite um comando: ")
    execute_user_input(cmd)