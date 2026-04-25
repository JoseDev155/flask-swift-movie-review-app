from database import db
from models import Pelicula

class MovieRepository:
    @staticmethod
    def get_by_api_id(api_id: int) -> Pelicula:
        return Pelicula.query.filter_by(api_id=api_id).first()

    @staticmethod
    def create(api_id: int, title: str, poster_path: str = None, overview: str = None, release_date: str = None) -> Pelicula:
        movie = Pelicula(
            api_id=api_id,
            title=title,
            poster_path=poster_path,
            overview=overview,
            release_date=release_date
        )
        db.session.add(movie)
        db.session.commit()
        return movie

    @staticmethod
    def get_all() -> list[Pelicula]:
        return Pelicula.query.all()
