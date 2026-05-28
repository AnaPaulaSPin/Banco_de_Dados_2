# app.py
# Ponto de entrada da aplicação Flask.
# Cria o app e registra todos os "blueprints" (grupos de rotas).

from flask import Flask

# Importa cada grupo de rotas (blueprint)
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

# Registra cada grupo de rotas no app principal
app.register_blueprint(cidades_bp)
app.register_blueprint(bairros_bp)
app.register_blueprint(unidades_bp)
app.register_blueprint(sistemas_bp)
app.register_blueprint(medicoes_bp)
app.register_blueprint(empresas_bp)
app.register_blueprint(contratos_bp)
app.register_blueprint(usuarios_bp)


# Inicia o servidor na porta 5000 com modo debug ativo
if __name__ == '__main__':
    app.run(debug=True, port=5000)