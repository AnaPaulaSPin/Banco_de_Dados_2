# routes/usuarios.py
# Endpoints para Usuario — controle de acesso ao sistema.
# Rotas: GET /usuarios, GET /usuarios/<id>, POST /usuarios,
#        PATCH /usuarios/<id>/status

from flask import Blueprint, jsonify, request
from database import get_connection

usuarios_bp = Blueprint('usuarios', __name__)

PERFIS_VALIDOS = ['ADMIN', 'GESTOR', 'OPERADOR']
STATUS_VALIDOS = ['ATIVO', 'INATIVO', 'SUSPENSO']


# ─────────────────────────────────────────────
# GET /usuarios
# Lista todos os usuários. NUNCA retorna a senha.
# ─────────────────────────────────────────────
@usuarios_bp.route('/usuarios', methods=['GET'])
def listar_usuarios():
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            # Nota: senha é intencionalmente omitida do SELECT
            cursor.execute("""
                SELECT idUsuario, nome, email, ultimoLogin, perfilAcesso, status
                FROM Usuario
                ORDER BY nome
            """)
            usuarios = cursor.fetchall()
        return jsonify(usuarios), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# GET /usuarios/<id>
# Retorna um usuário pelo ID (sem senha).
# ─────────────────────────────────────────────
@usuarios_bp.route('/usuarios/<int:id>', methods=['GET'])
def buscar_usuario(id):
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT idUsuario, nome, email, ultimoLogin, perfilAcesso, status
                FROM Usuario
                WHERE idUsuario = %s
            """, (id,))
            usuario = cursor.fetchone()
        if not usuario:
            return jsonify({'erro': 'Usuário não encontrado'}), 404
        return jsonify(usuario), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# POST /usuarios
# Cria um novo usuário com validações.
# Body JSON:
# {
#   "nome": "Maria Souza",
#   "email": "maria@gmail.com",
#   "senha": "senha123",
#   "perfilAcesso": "OPERADOR"
# }
# ─────────────────────────────────────────────
@usuarios_bp.route('/usuarios', methods=['POST'])
def criar_usuario():
    dados = request.get_json()

    campos_obrigatorios = ['nome', 'email', 'senha', 'perfilAcesso']
    for campo in campos_obrigatorios:
        if not dados.get(campo):
            return jsonify({'erro': f'Campo "{campo}" é obrigatório'}), 400

    # Validação de senha (trigger trg_usuario_senha_min também faz isso no banco)
    if len(dados['senha']) < 8:
        return jsonify({'erro': 'Senha deve ter no mínimo 8 caracteres'}), 400

    # Validação de email (trigger trg_usuario_email também faz isso no banco)
    if '@gmail.com' not in dados['email']:
        return jsonify({'erro': 'Email deve conter @gmail.com'}), 400

    if dados['perfilAcesso'] not in PERFIS_VALIDOS:
        return jsonify({'erro': f'perfilAcesso inválido. Use: {PERFIS_VALIDOS}'}), 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            # Checa email duplicado antes de tentar inserir
            cursor.execute(
                "SELECT idUsuario FROM Usuario WHERE email = %s", (dados['email'],)
            )
            if cursor.fetchone():
                return jsonify({'erro': 'Email já cadastrado'}), 409

            cursor.execute("""
                INSERT INTO Usuario
                    (nome, email, senha, ultimoLogin, perfilAcesso, status)
                VALUES (%s, %s, %s, NOW(), %s, 'ATIVO')
            """, (
                dados['nome'],
                dados['email'],
                dados['senha'],
                dados['perfilAcesso']
            ))
        conn.commit()
        return jsonify({'mensagem': 'Usuário criado com sucesso', 'id': cursor.lastrowid}), 201
    except Exception as e:
        conn.rollback()
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# PATCH /usuarios/<id>/status
# Exclusão lógica: inativa ou suspende um usuário.
# Body JSON: { "status": "INATIVO" }
# ─────────────────────────────────────────────
@usuarios_bp.route('/usuarios/<int:id>/status', methods=['PATCH'])
def atualizar_status_usuario(id):
    dados = request.get_json()
    novo_status = dados.get('status')

    if novo_status not in STATUS_VALIDOS:
        return jsonify({'erro': f'Status inválido. Use: {STATUS_VALIDOS}'}), 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "UPDATE Usuario SET status = %s WHERE idUsuario = %s",
                (novo_status, id)
            )
        conn.commit()
        if cursor.rowcount == 0:
            return jsonify({'erro': 'Usuário não encontrado'}), 404
        return jsonify({'mensagem': f'Status do usuário atualizado para {novo_status}'}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()