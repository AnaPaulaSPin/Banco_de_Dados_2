# database.py
# Cria a conexão com o banco usando o perfil da sessão do usuário logado.

import pymysql
import pymysql.cursors
from config import DB_AUTH, DB_PERFIS, DB_CONFIG


def get_connection(perfil=None):
    if perfil == 'AUTH':
        config = DB_AUTH
    else:
        config = DB_PERFIS.get(perfil, DB_CONFIG)

    return pymysql.connect(
        host=config['host'],
        user=config['user'],
        password=config['password'],
        database=config['database'],
        charset=config['charset'],
        cursorclass=pymysql.cursors.DictCursor
    )