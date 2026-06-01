# routes/contratos.py
# Endpoints para Contrato — o elo entre Unidade, Sistema e Empresa.
# Rotas: GET /contratos, GET /contratos/<id>, POST /contratos,
#        PATCH /contratos/<id>/status

from flask import Blueprint, jsonify, request
from database import get_connection

contratos_bp = Blueprint('contratos', __name__)

STATUS_VALIDOS = ['ATIVO', 'ENCERRADO', 'SUSPENSO']


# ─────────────────────────────────────────────
# GET /contratos
# Lista contratos. Aceita filtro por status via query string.
# Exemplos:
#   GET /contratos             → todos
#   GET /contratos?status=ATIVO   → só ativos
# ─────────────────────────────────────────────
@contratos_bp.route('/contratos', methods=['GET'])
def listar_contratos():
    # request.args lê parâmetros da URL: /contratos?status=ATIVO
    status_filtro = request.args.get('status', None)

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            if status_filtro:
                cursor.execute("""
                    SELECT
                        c.*,
                        uc.nomeResponsavel AS unidade,
                        ei.razaoSocial     AS empresa
                    FROM Contrato c
                    JOIN UnidadeConsumidora uc ON c.idUnidadeConsumidora = uc.idUnidadeConsumidora
                    JOIN EmpresaInstaladora  ei ON c.idEmpresaInstaladora = ei.idEmpresa
                    WHERE c.status = %s
                    ORDER BY c.dataInicio DESC
                """, (status_filtro.upper(),))
            else:
                cursor.execute("""
                    SELECT
                        c.*,
                        uc.nomeResponsavel AS unidade,
                        ei.razaoSocial     AS empresa
                    FROM Contrato c
                    JOIN UnidadeConsumidora uc ON c.idUnidadeConsumidora = uc.idUnidadeConsumidora
                    JOIN EmpresaInstaladora  ei ON c.idEmpresaInstaladora = ei.idEmpresa
                    ORDER BY c.dataInicio DESC
                """)
            contratos = cursor.fetchall()
        return jsonify(contratos), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# GET /contratos/<id>
# Retorna um contrato específico pelo ID.
# ─────────────────────────────────────────────
@contratos_bp.route('/contratos/<int:id>', methods=['GET'])
def buscar_contrato(id):
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT
                    c.*,
                    uc.nomeResponsavel AS unidade,
                    ei.razaoSocial     AS empresa
                FROM Contrato c
                JOIN UnidadeConsumidora uc ON c.idUnidadeConsumidora = uc.idUnidadeConsumidora
                JOIN EmpresaInstaladora  ei ON c.idEmpresaInstaladora = ei.idEmpresa
                WHERE c.idContrato = %s
            """, (id,))
            contrato = cursor.fetchone()
        if not contrato:
            return jsonify({'erro': 'Contrato não encontrado'}), 404
        return jsonify(contrato), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# POST /contratos
# Cria um novo contrato.
# Body JSON:
# {
#   "numero": 1001,
#   "dataInicio": "2025-01-01",
#   "dataFim": "2027-01-01",
#   "valor": 3500.00,
#   "observacao": "Contrato padrão",
#   "status": "ATIVO",
#   "idUnidadeConsumidora": 1,
#   "idSistemaPainel": 1,
#   "idEmpresaInstaladora": 1
# }
# ─────────────────────────────────────────────
@contratos_bp.route('/contratos', methods=['POST'])
def criar_contrato():
    dados = request.get_json()

    campos_obrigatorios = [
        'numero', 'dataInicio', 'dataFim', 'valor', 'status',
        'idUnidadeConsumidora', 'idSistemaPainel', 'idEmpresaInstaladora'
    ]
    for campo in campos_obrigatorios:
        if dados.get(campo) is None:
            return jsonify({'erro': f'Campo "{campo}" é obrigatório'}), 400

    if dados['status'] not in STATUS_VALIDOS:
        return jsonify({'erro': f'Status inválido. Use: {STATUS_VALIDOS}'}), 400

    if dados['valor'] <= 0:
        return jsonify({'erro': 'Valor do contrato deve ser maior que 0'}), 400

    # Valida que dataFim não é anterior a dataInicio (CHECK do banco também faz isso)
    if dados['dataFim'] < dados['dataInicio']:
        return jsonify({'erro': 'dataFim não pode ser anterior a dataInicio'}), 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO Contrato
                    (numero, dataInicio, dataFim, valor, observacao, status,
                     idUnidadeConsumidora, idSistemaPainel, idEmpresaInstaladora)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                dados['numero'],
                dados['dataInicio'],
                dados['dataFim'],
                dados['valor'],
                dados.get('observacao'),
                dados['status'],
                dados['idUnidadeConsumidora'],
                dados['idSistemaPainel'],
                dados['idEmpresaInstaladora']
            ))
        conn.commit()
        return jsonify({'mensagem': 'Contrato criado com sucesso', 'id': cursor.lastrowid}), 201
    except Exception as e:
        conn.rollback()
        if 'Duplicate entry' in str(e):
            return jsonify({'erro': 'Número de contrato já existe'}), 409
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# PATCH /contratos/<id>/status
# Exclusão lógica: encerra ou suspende um contrato.
# Body JSON: { "status": "ENCERRADO" }
# ─────────────────────────────────────────────
@contratos_bp.route('/contratos/<int:id>/status', methods=['PATCH'])
def atualizar_status_contrato(id):
    dados = request.get_json()
    novo_status = dados.get('status')

    if novo_status not in STATUS_VALIDOS:
        return jsonify({'erro': f'Status inválido. Use: {STATUS_VALIDOS}'}), 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "UPDATE Contrato SET status = %s WHERE idContrato = %s",
                (novo_status, id)
            )
        conn.commit()
        if cursor.rowcount == 0:
            return jsonify({'erro': 'Contrato não encontrado'}), 404
        return jsonify({'mensagem': f'Status do contrato atualizado para {novo_status}'}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()