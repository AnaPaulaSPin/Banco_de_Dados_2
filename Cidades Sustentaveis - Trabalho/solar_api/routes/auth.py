# routes/auth.py
from flask import Blueprint, request, jsonify, session, render_template
from database import get_connection

auth_bp = Blueprint('auth', __name__)


@auth_bp.route('/login', methods=['GET'])
def tela_login():
    return render_template('login.html')


@auth_bp.route('/auth/login', methods=['POST'])
def login():
    dados = request.get_json()
    email = dados.get('email', '').strip()
    senha = dados.get('senha', '').strip()

    if not email or not senha:
        return jsonify({'erro': 'Email e senha são obrigatórios'}), 400

    conn = get_connection('AUTH')  # auth_solar — lê só a tabela Usuario
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT idUsuario, nome, email, perfilAcesso, status
                FROM Usuario
                WHERE email = %s AND senha = %s
            """, (email, senha))
            usuario = cursor.fetchone()
    finally:
        conn.close()

    if not usuario:
        return jsonify({'erro': 'Email ou senha inválidos'}), 401

    if usuario['status'] != 'ATIVO':
        return jsonify({'erro': f'Usuário {usuario["status"].lower()}. Acesso negado.'}), 403

    session['usuario_id']   = usuario['idUsuario']
    session['usuario_nome'] = usuario['nome']
    session['perfil']       = usuario['perfilAcesso']

    return jsonify({
        'mensagem': 'Login realizado com sucesso',
        'nome':     usuario['nome'],
        'perfil':   usuario['perfilAcesso']
    }), 200


@auth_bp.route('/auth/logout', methods=['POST'])
def logout():
    session.clear()
    return jsonify({'mensagem': 'Logout realizado com sucesso'}), 200


@auth_bp.route('/auth/me', methods=['GET'])
def me():
    if 'perfil' not in session:
        return jsonify({'erro': 'Não autenticado'}), 401
    return jsonify({
        'nome':   session['usuario_nome'],
        'perfil': session['perfil']
    }), 200