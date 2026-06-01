# database.py
# Responsável por criar e retornar a conexão com o MySQL.
# Usa DictCursor: os resultados vêm como dicionários {coluna: valor},
# o que é ideal para converter para JSON depois.

import pymysql
import pymysql.cursors
from config import DB_CONFIG


def get_connection():
    """
    Cria e retorna uma conexão com o banco de dados MySQL.

    DictCursor faz os resultados das queries virem como dicionários:
    Ex: {'idCidade': 1, 'nome': 'Salvador'} ao invés de (1, 'Salvador')

    Isso facilita muito na hora de converter para JSON nas rotas.
    """
    return pymysql.connect(
        host=DB_CONFIG['host'],
        user=DB_CONFIG['user'],
        password=DB_CONFIG['password'],
        database=DB_CONFIG['database'],
        charset=DB_CONFIG['charset'],
        cursorclass=pymysql.cursors.DictCursor  # retorna dicionários, não tuplas
    )