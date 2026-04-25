import os
from flask import Flask
from dotenv import load_dotenv

# Cargar variables de entorno lo antes posible
load_dotenv()

from flask_smorest import Api
from database import db, ma, Config
from utils import bcrypt, jwt

# Importar los modelos para que SQLAlchemy los registre
from models import usuario, pelicula, favorito, refresh_token

# Importar Blueprints de flask-smorest
from routes import auth_bp, movie_bp, favorite_bp, user_bp

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    # Inicializar extensiones
    db.init_app(app)
    ma.init_app(app)
    bcrypt.init_app(app)
    jwt.init_app(app)
    
    api = Api(app)

    # Registrar Blueprints en la Api de smorest
    api.register_blueprint(auth_bp)
    api.register_blueprint(movie_bp)
    api.register_blueprint(favorite_bp)
    api.register_blueprint(user_bp)

    @app.route("/")
    def home():
        return {"message": "Movie Review API v1.0.0"}

    return app