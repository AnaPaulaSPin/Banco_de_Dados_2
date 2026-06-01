# routes/unidades.py
# Endpoints para UnidadeConsumidora.
# Rotas: GET /unidades, GET /unidades/<id>, POST /unidades, PUT /unidades/<id>

from flask import Blueprint, jsonify, request
from database import get_connection

unidades_bp = Blueprint('unidades', __name__)

# Valores permitidos pelo ENUM no banco
TIPOS_UNIDADE = ['RESIDENCIAL', 'COMERCIAL', 'PUBLICA', 'INDUSTRIAL']


# ─────────────────────────────────────────────
# GET /unidades
# Lista todas as unidades consumidoras com bairro e cidade.
# ─────────────────────────────────────────────
@unidades_bp.route('/unidades', methods=['GET'])
def listar_unidades():
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT
                    uc.idUnidadeConsumidora,
                    uc.nomeResponsavel,
                    uc.tipoUnidade,
                    uc.logradouro,
                    uc.numeroResidencia,
                    uc.telefone,
                    uc.email,
                    uc.dataCadastro,
                    b.nome  AS bairro,
                    ci.nome AS cidade
                FROM UnidadeConsumidora uc
                JOIN Bairro b  ON uc.idBairro   = b.idBairro
                JOIN Cidade ci ON b.idCidade     = ci.idCidade
                ORDER BY uc.nomeResponsavel
            """)
            unidades = cursor.fetchall()
        return jsonify(unidades), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# GET /unidades/<id>
# Retorna uma unidade consumidora pelo ID.
# ─────────────────────────────────────────────
@unidades_bp.route('/unidades/<int:id>', methods=['GET'])
def buscar_unidade(id):
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT
                    uc.*,
                    b.nome  AS bairro,
                    ci.nome AS cidade
                FROM UnidadeConsumidora uc
                JOIN Bairro b  ON uc.idBairro = b.idBairro
                JOIN Cidade ci ON b.idCidade   = ci.idCidade
                WHERE uc.idUnidadeConsumidora = %s
            """, (id,))
            unidade = cursor.fetchone()
        if not unidade:
            return jsonify({'erro': 'Unidade consumidora não encontrada'}), 404
        return jsonify(unidade), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# POST /unidades
# Cadastra uma nova unidade consumidora.
# Body JSON esperado:
# {
#   "nomeResponsavel": "João Silva",
#   "tipoUnidade": "RESIDENCIAL",
#   "logradouro": "Rua das Flores",
#   "numeroResidencia": "123",
#   "telefone": "71999998888",
#   "email": "joao@gmail.com",
#   "dataCadastro": "2025-01-15",
#   "idBairro": 2
# }
# ─────────────────────────────────────────────
@unidades_bp.route('/unidades', methods=['POST'])
def criar_unidade():
    dados = request.get_json()

    # Valida campos obrigatórios
    campos_obrigatorios = [
        'nomeResponsavel', 'tipoUnidade', 'logradouro',
        'numeroResidencia', 'telefone', 'dataCadastro', 'idBairro'
    ]
    for campo in campos_obrigatorios:
        if not dados.get(campo):
            return jsonify({'erro': f'Campo "{campo}" é obrigatório'}), 400

    # Valida o tipo de unidade (deve ser um dos valores do ENUM)
    if dados['tipoUnidade'] not in TIPOS_UNIDADE:
        return jsonify({'erro': f'tipoUnidade inválido. Use um de: {TIPOS_UNIDADE}'}), 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO UnidadeConsumidora
                    (nomeResponsavel, tipoUnidade, logradouro, numeroResidencia,
                     telefone, email, dataCadastro, idBairro)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                dados['nomeResponsavel'],
                dados['tipoUnidade'],
                dados['logradouro'],
                dados['numeroResidencia'],
                dados['telefone'],
                dados.get('email'),          # email é opcional no schema
                dados['dataCadastro'],
                dados['idBairro']
            ))
        conn.commit()
        return jsonify({'mensagem': 'Unidade consumidora criada com sucesso', 'id': cursor.lastrowid}), 201
    except Exception as e:
        conn.rollback()
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# PUT /unidades/<id>
# Atualiza telefone e email de uma unidade consumidora.
# Body JSON: { "telefone": "71999991111", "email": "novo@gmail.com" }
# ─────────────────────────────────────────────
@unidades_bp.route('/unidades/<int:id>', methods=['PUT'])
def atualizar_unidade(id):
    dados = request.get_json()
    telefone = dados.get('telefone')
    email    = dados.get('email')

    if not telefone:
        return jsonify({'erro': 'Campo "telefone" é obrigatório'}), 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                UPDATE UnidadeConsumidora
                SET telefone = %s, email = %s
                WHERE idUnidadeConsumidora = %s
            """, (telefone, email, id))
        conn.commit()
        if cursor.rowcount == 0:
            return jsonify({'erro': 'Unidade consumidora não encontrada'}), 404
        return jsonify({'mensagem': 'Unidade consumidora atualizada com sucesso'}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()