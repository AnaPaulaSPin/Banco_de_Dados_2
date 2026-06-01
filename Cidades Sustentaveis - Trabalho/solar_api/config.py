# config.py
# Configurações de conexão por perfil de acesso.

# Credencial dedicada APENAS para validar login (lê só a tabela Usuario)
DB_AUTH = {
    'host':     'localhost',
    'user':     'auth_solar',
    'password': 'Auth@Solar2026',
    'database': 'SistemaEnergiaSolar',
    'charset':  'utf8mb4'
}

# Credenciais por perfil — usadas após o login
DB_PERFIS = {
    'ADMIN': {
        'host':     'localhost',
        'user':     'admin_solar',
        'password': 'Admin@Solar2026',
        'database': 'SistemaEnergiaSolar',
        'charset':  'utf8mb4'
    },
    'GESTOR': {
        'host':     'localhost',
        'user':     'gestor_solar',
        'password': 'Gestor@Solar2026',
        'database': 'SistemaEnergiaSolar',
        'charset':  'utf8mb4'
    },
    'OPERADOR': {
        'host':     'localhost',
        'user':     'operador_solar',
        'password': 'Operador@Solar2026',
        'database': 'SistemaEnergiaSolar',
        'charset':  'utf8mb4'
    },
}

# Fallback se o perfil não for reconhecido
DB_CONFIG = DB_PERFIS['OPERADOR']