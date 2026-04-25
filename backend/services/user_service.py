from repositories import UserRepository
from models import usuario_schema

class UserService:
    @staticmethod
    def get_user_profile(user_id: int):
        user = UserRepository.get_by_id(user_id)
        if not user:
            return {"error": "Usuario no encontrado"}, 404
        return {"usuario": usuario_schema.dump(user)}, 200

    @staticmethod
    def update_profile(user_id: int, data: dict):
        user = UserRepository.get_by_id(user_id)
        if not user:
            return {"error": "Usuario no encontrado"}, 404
        
        # Solo permitir actualizar email por ahora como ejemplo
        email = data.get('email')
        if email:
            existing = UserRepository.get_by_email(email)
            if existing and existing.id != user_id:
                return {"error": "El correo electrónico ya está en uso"}, 400
            user.email = email
            from database import db
            db.session.commit()
            
        return {"message": "Perfil actualizado exitosamente", "usuario": usuario_schema.dump(user)}, 200
