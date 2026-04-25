from flask import request
from . import auth_bp
from services import AuthService
from flask_jwt_extended import jwt_required, get_jwt_identity, get_jwt

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    response, status = AuthService.register_user(data)
    return response, status

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    response, status = AuthService.login_user(data)
    return response, status

@auth_bp.route('/refresh', methods=['POST'])
@jwt_required(refresh=True)
def refresh():
    current_user_id = get_jwt_identity()
    refresh_token = get_jwt()['jti'] # Asumiendo que el modelo guarda el token entero, podríamos usar request.headers, pero aquí usamos get_jwt. En auth_service.refresh_token esperamos el token string.
    # Corrección: El token string lo obtenemos de request.headers.get('Authorization').split(" ")[1] o pasamos otra cosa.
    # Mejor pasamos el string del token:
    auth_header = request.headers.get('Authorization', '')
    token_str = auth_header.replace('Bearer ', '').strip() if 'Bearer ' in auth_header else auth_header

    response, status = AuthService.refresh_token(current_user_id, token_str)
    return response, status

@auth_bp.route('/logout', methods=['POST'])
@jwt_required(refresh=True) # Requiere el refresh token para revocarlo
def logout():
    auth_header = request.headers.get('Authorization', '')
    token_str = auth_header.replace('Bearer ', '').strip() if 'Bearer ' in auth_header else auth_header
    
    response, status = AuthService.logout_user(token_str)
    return response, status
