from database import db
from models import RefreshToken

class TokenRepository:
    @staticmethod
    def save(token: str, usuario_id: int) -> RefreshToken:
        new_token = RefreshToken(token=token, usuario_id=usuario_id)
        db.session.add(new_token)
        db.session.commit()
        return new_token

    @staticmethod
    def get_by_token(token: str) -> RefreshToken:
        return RefreshToken.query.filter_by(token=token).first()

    @staticmethod
    def delete(token: str):
        token_obj = RefreshToken.query.filter_by(token=token).first()
        if token_obj:
            db.session.delete(token_obj)
            db.session.commit()
