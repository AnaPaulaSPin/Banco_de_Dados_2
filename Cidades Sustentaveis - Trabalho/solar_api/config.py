# config.py
# Centraliza as configurações de conexão com o banco de dados.
# Altere os valores abaixo para os da sua máquina.

DB_CONFIG = {
    'host':     'localhost',            # endereço do servidor MySQL
    'user':     'admin_solar',                 # usuário do MySQL (troque pelo seu)
    'password': 'Admin@Solar2026',                     # senha do MySQL (troque pela sua)
    'database': 'SistemaEnergiaSolar',  # nome do banco criado pelo script DDL
    'charset':  'utf8mb4'              # suporte a caracteres especiais (acentos)
}