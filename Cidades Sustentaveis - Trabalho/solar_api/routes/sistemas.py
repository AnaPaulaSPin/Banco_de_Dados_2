# routes/sistemas.py
# Endpoints para SistemaPainel (o sistema de geração solar de uma unidade).
# Rotas: GET /sistemas, GET /sistemas/<id>, GET /sistemas/<id>/paineis,
#        POST /sistemas, PATCH /sistemas/<id>/status

from flask import Blueprint, jsonify, request
from database import get_connection

sistemas_bp = Blueprint('sistemas', __name__)

STATUS_VALIDOS = ['ATIVO', 'INATIVO', 'MANUTENCAO']


# ─────────────────────────────────────────────
# GET /sistemas
# Lista todos os sistemas de painéis cadastrados.
# ─────────────────────────────────────────────
@sistemas_bp.route('/sistemas', methods=['GET'])
def listar_sistemas():
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM SistemaPainel ORDER BY dataInstalacao DESC")
            sistemas = cursor.fetchall()
        return jsonify(sistemas), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# GET /sistemas/<id>
# Busca um sistema de painéis pelo ID.
# ─────────────────────────────────────────────
@sistemas_bp.route('/sistemas/<int:id>', methods=['GET'])
def buscar_sistema(id):
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM SistemaPainel WHERE idSistemaPainel = %s", (id,))
            sistema = cursor.fetchone()
        if not sistema:
            return jsonify({'erro': 'Sistema de painéis não encontrado'}), 404
        return jsonify(sistema), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# GET /sistemas/<id>/paineis
# Lista todos os painéis solares de um sistema.
# ─────────────────────────────────────────────
@sistemas_bp.route('/sistemas/<int:id>/paineis', methods=['GET'])
def paineis_do_sistema(id):
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT * FROM PainelSolar
                WHERE idSistemaPainel = %s
                ORDER BY modelo
            """, (id,))
            paineis = cursor.fetchall()
        return jsonify(paineis), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# POST /sistemas
# Cadastra um novo sistema de painéis.
# Body JSON:
# {
#   "capacidadeKwp": 5.2,
#   "dataInstalacao": "2024-03-10 08:00:00",
#   "vidaUtilEstimada": 25,
#   "status": "ATIVO"
# }
# ─────────────────────────────────────────────
@sistemas_bp.route('/sistemas', methods=['POST'])
def criar_sistema():
    dados = request.get_json()

    campos_obrigatorios = ['capacidadeKwp', 'dataInstalacao', 'vidaUtilEstimada', 'status']
    for campo in campos_obrigatorios:
        if dados.get(campo) is None:
            return jsonify({'erro': f'Campo "{campo}" é obrigatório'}), 400

    if dados['status'] not in STATUS_VALIDOS:
        return jsonify({'erro': f'Status inválido. Use: {STATUS_VALIDOS}'}), 400

    if dados['capacidadeKwp'] <= 0:
        return jsonify({'erro': 'capacidadeKwp deve ser maior que 0'}), 400

    if dados['vidaUtilEstimada'] <= 0:
        return jsonify({'erro': 'vidaUtilEstimada deve ser maior que 0'}), 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO SistemaPainel
                    (capacidadeKwp, dataInstalacao, vidaUtilEstimada, status)
                VALUES (%s, %s, %s, %s)
            """, (
                dados['capacidadeKwp'],
                dados['dataInstalacao'],
                dados['vidaUtilEstimada'],
                dados['status']
            ))
        conn.commit()
        return jsonify({'mensagem': 'Sistema de painéis criado com sucesso', 'id': cursor.lastrowid}), 201
    except Exception as e:
        conn.rollback()
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# PATCH /sistemas/<id>/status
# Atualiza apenas o status de um sistema (exclusão lógica).
# Body JSON: { "status": "INATIVO" }
# PATCH é mais correto que PUT quando atualiza só 1 campo.
# ─────────────────────────────────────────────
@sistemas_bp.route('/sistemas/<int:id>/status', methods=['PATCH'])
def atualizar_status_sistema(id):
    dados = request.get_json()
    novo_status = dados.get('status')

    if novo_status not in STATUS_VALIDOS:
        return jsonify({'erro': f'Status inválido. Use: {STATUS_VALIDOS}'}), 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "UPDATE SistemaPainel SET status = %s WHERE idSistemaPainel = %s",
                (novo_status, id)
            )
        conn.commit()
        if cursor.rowcount == 0:
            return jsonify({'erro': 'Sistema não encontrado'}), 404
        return jsonify({'mensagem': f'Status atualizado para {novo_status}'}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()