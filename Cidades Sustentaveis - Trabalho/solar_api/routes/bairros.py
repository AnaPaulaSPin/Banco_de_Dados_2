# routes/bairros.py
# Endpoints para gerenciar Bairros.
# Rotas: GET /bairros, GET /bairros/<id>, GET /bairros/cidade/<id>, POST /bairros

from flask import Blueprint, jsonify, request
from database import get_connection

bairros_bp = Blueprint('bairros', __name__)


# ─────────────────────────────────────────────
# GET /bairros
# Lista todos os bairros com o nome da cidade (JOIN).
# ─────────────────────────────────────────────
@bairros_bp.route('/bairros', methods=['GET'])
def listar_bairros():
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT
                    b.idBairro,
                    b.nome      AS bairro,
                    b.regiao,
                    ci.idCidade,
                    ci.nome     AS cidade
                FROM Bairro b
                JOIN Cidade ci ON b.idCidade = ci.idCidade
                ORDER BY ci.nome, b.nome
            """)
            bairros = cursor.fetchall()
        return jsonify(bairros), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# GET /bairros/<id>
# Retorna um bairro específico pelo ID.
# ─────────────────────────────────────────────
@bairros_bp.route('/bairros/<int:id>', methods=['GET'])
def buscar_bairro(id):
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT b.idBairro, b.nome AS bairro, b.regiao, b.idCidade, ci.nome AS cidade
                FROM Bairro b
                JOIN Cidade ci ON b.idCidade = ci.idCidade
                WHERE b.idBairro = %s
            """, (id,))
            bairro = cursor.fetchone()
        if not bairro:
            return jsonify({'erro': 'Bairro não encontrado'}), 404
        return jsonify(bairro), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# GET /bairros/cidade/<id_cidade>
# Lista todos os bairros de uma cidade específica.
# ─────────────────────────────────────────────
@bairros_bp.route('/bairros/cidade/<int:id_cidade>', methods=['GET'])
def bairros_por_cidade(id_cidade):
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT idBairro, nome, regiao
                FROM Bairro
                WHERE idCidade = %s
                ORDER BY nome
            """, (id_cidade,))
            bairros = cursor.fetchall()
        return jsonify(bairros), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# POST /bairros
# Cadastra um novo bairro.
# Body JSON: { "nome": "Barra", "regiao": "Oeste", "idCidade": 1 }
# ─────────────────────────────────────────────
@bairros_bp.route('/bairros', methods=['POST'])
def criar_bairro():
    dados = request.get_json()
    nome      = dados.get('nome')
    regiao    = dados.get('regiao')
    id_cidade = dados.get('idCidade')

    if not all([nome, regiao, id_cidade]):
        return jsonify({'erro': 'Campos "nome", "regiao" e "idCidade" são obrigatórios'}), 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "INSERT INTO Bairro (nome, regiao, idCidade) VALUES (%s, %s, %s)",
                (nome, regiao, id_cidade)
            )
        conn.commit()
        return jsonify({'mensagem': 'Bairro criado com sucesso', 'id': cursor.lastrowid}), 201
    except Exception as e:
        conn.rollback()
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()