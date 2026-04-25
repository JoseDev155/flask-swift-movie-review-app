from repositories import UserRepository, TokenRepository
from utils import hash_password, verify_password, generate_tokens, decode_jwt_token
from flask_jwt_extended.exceptions import RevokedTokenError

class AuthService:
    @staticmethod
    def register_user(data: dict):
        # Swift envía 'nombre' en lugar de 'username'
        username = data.get('nombre') or data.get('username')
        email = data.get('email')
        password = data.get('password')

        if not username or not email or not password:
            return {"error": "Faltan datos requeridos (nombre, email, password)"}, 400

        if UserRepository.get_by_username(username):
            return {"error": "El nombre de usuario ya está en uso"}, 400
        
        if UserRepository.get_by_email(email):
            return {"error": "El correo electrónico ya está en uso"}, 400

        hashed_password = hash_password(password)
        new_user = UserRepository.create(username, email, hashed_password)
        
        # Swift espera {"success": true, "message": "..."}
        return {"success": True, "message": "Usuario registrado exitosamente"}, 200

    @staticmethod
    def login_user(data: dict):
        # Swift envía 'email' en lugar de 'username'
        email = data.get('email')
        password = data.get('password')

        if not email or not password:
            return {"error": "Faltan datos requeridos (email, password)"}, 400

        user = UserRepository.get_by_email(email)
        if not user or not verify_password(user.password_hash, password):
            return {"error": "Credenciales inválidas"}, 401

        tokens = generate_tokens(identity=str(user.id))
        TokenRepository.save(tokens['refresh_token'], user.id)

        # Swift espera {"token": "...", "refresh_token": "...", "user_name": "...", "email": "..."}
        return {
            "token": tokens['access_token'],
            "refresh_token": tokens['refresh_token'],
            "user_name": user.username,
            "email": user.email
        }, 200

    @staticmethod
    def refresh_token(current_user_id: str, token: str):
        token_obj = TokenRepository.get_by_token(token)
        if not token_obj:
            return {"error": "Refresh token inválido o no encontrado en la base de datos"}, 401

        new_tokens = generate_tokens(identity=current_user_id)
        
        # Eliminar el token viejo y guardar el nuevo
        TokenRepository.delete(token)
        TokenRepository.save(new_tokens['refresh_token'], current_user_id)

        return {
            "access_token": new_tokens['access_token'],
            "refresh_token": new_tokens['refresh_token']
        }, 200

    @staticmethod
    def logout_user(token: str):
        token_obj = TokenRepository.get_by_token(token)
        if token_obj:
            TokenRepository.delete(token)
        return {"message": "Sesión cerrada exitosamente"}, 200
