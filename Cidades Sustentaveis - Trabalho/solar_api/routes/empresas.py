# routes/empresas.py
# Endpoints para EmpresaInstaladora.
# Rotas: GET /empresas, GET /empresas/<id>, POST /empresas,
#        GET /empresas/<id>/contratos

from flask import Blueprint, jsonify, request
from database import get_connection

empresas_bp = Blueprint('empresas', __name__)


# ─────────────────────────────────────────────
# GET /empresas
# Lista todas as empresas instaladoras.
# ─────────────────────────────────────────────
@empresas_bp.route('/empresas', methods=['GET'])
def listar_empresas():
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM EmpresaInstaladora ORDER BY razaoSocial")
            empresas = cursor.fetchall()
        return jsonify(empresas), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# GET /empresas/<id>
# Retorna uma empresa pelo ID.
# ─────────────────────────────────────────────
@empresas_bp.route('/empresas/<int:id>', methods=['GET'])
def buscar_empresa(id):
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "SELECT * FROM EmpresaInstaladora WHERE idEmpresa = %s", (id,)
            )
            empresa = cursor.fetchone()
        if not empresa:
            return jsonify({'erro': 'Empresa não encontrada'}), 404
        return jsonify(empresa), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# GET /empresas/<id>/contratos
# Lista todos os contratos de uma empresa instaladora.
# ─────────────────────────────────────────────
@empresas_bp.route('/empresas/<int:id>/contratos', methods=['GET'])
def contratos_da_empresa(id):
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT
                    c.idContrato,
                    c.numero,
                    c.dataInicio,
                    c.dataFim,
                    c.valor,
                    c.status,
                    uc.nomeResponsavel AS unidade_consumidora,
                    sp.capacidadeKwp
                FROM Contrato c
                JOIN UnidadeConsumidora uc ON c.idUnidadeConsumidora = uc.idUnidadeConsumidora
                JOIN SistemaPainel      sp ON c.idSistemaPainel      = sp.idSistemaPainel
                WHERE c.idEmpresaInstaladora = %s
                ORDER BY c.dataInicio DESC
            """, (id,))
            contratos = cursor.fetchall()
        return jsonify(contratos), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# POST /empresas
# Cadastra uma nova empresa instaladora.
# Body JSON:
# {
#   "razaoSocial": "Solar Tech Ltda",
#   "cnpj": "12345678000195",
#   "email": "contato@solartech.com",
#   "logradouro": "Av. da Saudade",
#   "numeroResidencia": "500"
# }
# ─────────────────────────────────────────────
@empresas_bp.route('/empresas', methods=['POST'])
def criar_empresa():
    dados = request.get_json()

    campos_obrigatorios = ['razaoSocial', 'cnpj', 'email', 'logradouro', 'numeroResidencia']
    for campo in campos_obrigatorios:
        if not dados.get(campo):
            return jsonify({'erro': f'Campo "{campo}" é obrigatório'}), 400

    # CNPJ deve ter exatamente 14 dígitos numéricos (sem pontuação)
    if len(str(dados['cnpj'])) != 14:
        return jsonify({'erro': 'CNPJ deve ter exatamente 14 dígitos (sem pontuação ou traços)'}), 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO EmpresaInstaladora
                    (razaoSocial, cnpj, email, logradouro, numeroResidencia)
                VALUES (%s, %s, %s, %s, %s)
            """, (
                dados['razaoSocial'],
                dados['cnpj'],
                dados['email'],
                dados['logradouro'],
                dados['numeroResidencia']
            ))
        conn.commit()
        return jsonify({'mensagem': 'Empresa cadastrada com sucesso', 'id': cursor.lastrowid}), 201
    except Exception as e:
        conn.rollback()
        # Trata erro de UNIQUE (CNPJ ou email duplicado)
        if 'Duplicate entry' in str(e):
            return jsonify({'erro': 'CNPJ ou e-mail já cadastrado'}), 409
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()