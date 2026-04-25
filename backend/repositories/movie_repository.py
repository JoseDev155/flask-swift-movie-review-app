from database import db
from models import Pelicula

class MovieRepository:
    @staticmethod
    def get_by_api_id(api_id: int) -> Pelicula:
        return Pelicula.query.filter_by(api_id=api_id).first()

    @staticmethod
    def get_by_id(movie_id: int) -> Pelicula:
        return Pelicula.query.get(movie_id)

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

    @staticmethod
    def update(movie: Pelicula, title: str = None, poster_path: str = None, overview: str = None, release_date: str = None) -> Pelicula:
        if title is not None:
            movie.title = title

        if poster_path is not None:
            movie.poster_path = poster_path

        if overview is not None:
            movie.overview = overview

        if release_date is not None:
            movie.release_date = release_date

        db.session.commit()
        return movie

    @staticmethod
    def delete(movie: Pelicula):
        db.session.delete(movie)
        db.session.commit()
