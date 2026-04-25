from flask_smorest import Blueprint

auth_bp = Blueprint('auth', 'auth', url_prefix='/api', description='Operaciones de autenticación')
movie_bp = Blueprint('movies', 'movies', url_prefix='/api/movies', description='Operaciones de películas')
favorite_bp = Blueprint('favorites', 'favorites', url_prefix='/api/favorites', description='Operaciones de favoritos')
user_bp = Blueprint('users', 'users', url_prefix='/api/users', description='Operaciones de usuarios')

from .auth_routes import *
from .movie_routes import *
from .favorite_routes import *
from .user_routes import *
