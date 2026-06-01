# app.py
# Ponto de entrada da aplicação Flask.

from flask import Flask, render_template, session, redirect, url_for

# Importa cada grupo de rotas (blueprint)
from routes.auth      import auth_bp
from routes.cidades   import cidades_bp
from routes.bairros   import bairros_bp
from routes.unidades  import unidades_bp
from routes.sistemas  import sistemas_bp
from routes.medicoes  import medicoes_bp
from routes.empresas  import empresas_bp
from routes.contratos import contratos_bp
from routes.usuarios  import usuarios_bp

# Cria a aplicação Flask
app = Flask(__name__)

# Chave secreta necessária para o Flask assinar os cookies de sessão
app.secret_key = 'solar2026-chave-secreta'

# Registra cada grupo de rotas no app principal
app.register_blueprint(auth_bp)
app.register_blueprint(cidades_bp)
app.register_blueprint(bairros_bp)
app.register_blueprint(unidades_bp)
app.register_blueprint(sistemas_bp)
app.register_blueprint(medicoes_bp)
app.register_blueprint(empresas_bp)
app.register_blueprint(contratos_bp)
app.register_blueprint(usuarios_bp)


@app.route('/')
def index():
    # Se não estiver logado, vai para o login
    if 'perfil' not in session:
        return redirect(url_for('auth.tela_login'))
    return render_template('index.html')

# Inicia o servidor na porta 5000 com modo debug ativo
if __name__ == '__main__':
    app.run(debug=True, port=5000)