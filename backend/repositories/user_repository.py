from database import db
from models import Usuario

class UserRepository:
    @staticmethod
    def get_by_id(user_id: int) -> Usuario:
        return Usuario.query.get(user_id)

    @staticmethod
    def get_by_username(username: str) -> Usuario:
        return Usuario.query.filter_by(username=username).first()

    @staticmethod
    def get_by_email(email: str) -> Usuario:
        return Usuario.query.filter_by(email=email).first()

    @staticmethod
    def create(username: str, email: str, password_hash: str) -> Usuario:
        new_user = Usuario(username=username, email=email, password_hash=password_hash)
        db.session.add(new_user)
        db.session.commit()
        return new_user
