from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager

bcrypt = Bcrypt()
jwt = JWTManager()

from .security import hash_password, verify_password
from .jwt_manager import generate_tokens, decode_jwt_token
from .tmdb_client import fetch_movie_details, fetch_movies_page
from .tmdb_client import fetch_movie_details
