from database import db
from models import Favorito

class FavoriteRepository:
    @staticmethod
    def get_by_user_and_movie(usuario_id: int, pelicula_id: int) -> Favorito:
        return Favorito.query.filter_by(usuario_id=usuario_id, pelicula_id=pelicula_id).first()

    @staticmethod
    def add(usuario_id: int, pelicula_id: int) -> Favorito:
        favorito = Favorito(usuario_id=usuario_id, pelicula_id=pelicula_id)
        db.session.add(favorito)
        db.session.commit()
        return favorito

    @staticmethod
    def remove(favorito: Favorito):
        db.session.delete(favorito)
        db.session.commit()

    @staticmethod
    def get_all_by_user(usuario_id: int) -> list[Favorito]:
        return Favorito.query.filter_by(usuario_id=usuario_id).all()
