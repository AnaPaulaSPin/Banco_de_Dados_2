# routes/cidades.py
# Endpoints para gerenciar Cidades.
# Rotas: GET /cidades, GET /cidades/<id>, POST /cidades, PUT /cidades/<id>

from flask import Blueprint, jsonify, request
from database import get_connection

# Blueprint é um "mini-app" com suas próprias rotas.
# O nome 'cidades' é usado internamente pelo Flask.
cidades_bp = Blueprint('cidades', __name__)


# ─────────────────────────────────────────────
# GET /cidades
# Retorna a lista de todas as cidades cadastradas.
# ─────────────────────────────────────────────
@cidades_bp.route('/cidades', methods=['GET'])
def listar_cidades():
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM Cidade")
            cidades = cursor.fetchall()          # busca todos os resultados
        return jsonify(cidades), 200             # converte lista para JSON
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()                             # SEMPRE fecha a conexão


# ─────────────────────────────────────────────
# GET /cidades/<id>
# Retorna uma cidade específica pelo seu ID.
# ─────────────────────────────────────────────
@cidades_bp.route('/cidades/<int:id>', methods=['GET'])
def buscar_cidade(id):
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            # %s é o placeholder seguro do PyMySQL (previne SQL Injection)
            cursor.execute("SELECT * FROM Cidade WHERE idCidade = %s", (id,))
            cidade = cursor.fetchone()           # busca apenas um resultado
        if not cidade:
            return jsonify({'erro': 'Cidade não encontrada'}), 404
        return jsonify(cidade), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# POST /cidades
# Cadastra uma nova cidade.
# Body JSON esperado: { "nome": "Salvador" }
# ─────────────────────────────────────────────
@cidades_bp.route('/cidades', methods=['POST'])
def criar_cidade():
    dados = request.get_json()           # lê o JSON enviado no body da requisição
    nome = dados.get('nome')

    if not nome:
        return jsonify({'erro': 'Campo "nome" é obrigatório'}), 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "INSERT INTO Cidade (nome) VALUES (%s)",
                (nome,)
            )
        conn.commit()                    # confirma a gravação no banco
        return jsonify({
            'mensagem': 'Cidade criada com sucesso',
            'id': cursor.lastrowid       # retorna o ID gerado automaticamente
        }), 201
    except Exception as e:
        conn.rollback()                  # desfaz a operação em caso de erro
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# PUT /cidades/<id>
# Atualiza o nome de uma cidade existente.
# Body JSON esperado: { "nome": "Novo Nome" }
# ─────────────────────────────────────────────
@cidades_bp.route('/cidades/<int:id>', methods=['PUT'])
def atualizar_cidade(id):
    dados = request.get_json()
    nome = dados.get('nome')

    if not nome:
        return jsonify({'erro': 'Campo "nome" é obrigatório'}), 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "UPDATE Cidade SET nome = %s WHERE idCidade = %s",
                (nome, id)
            )
        conn.commit()
        if cursor.rowcount == 0:         # rowcount = quantas linhas foram afetadas
            return jsonify({'erro': 'Cidade não encontrada'}), 404
        return jsonify({'mensagem': 'Cidade atualizada com sucesso'}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()