from repositories import MovieRepository
from models import pelicula_schema, peliculas_schema

class MovieService:
    @staticmethod
    def get_all_movies():
        movies = MovieRepository.get_all()
        return {"peliculas": peliculas_schema.dump(movies)}, 200

    @staticmethod
    def add_movie(data: dict):
        api_id = data.get('api_id')
        title = data.get('title')

        if not api_id or not title:
            return {"error": "Faltan datos requeridos (api_id, title)"}, 400
        
        # Validar tipo de dato de api_id
        if not isinstance(api_id, int):
            try:
                api_id = int(api_id)
            except ValueError:
                return {"error": "El campo api_id debe ser un entero"}, 400

        existing = MovieRepository.get_by_api_id(api_id)
        if existing:
            return {"message": "La película ya existe en caché", "pelicula": pelicula_schema.dump(existing)}, 200

        poster_path = data.get('poster_path')
        overview = data.get('overview')
        release_date = data.get('release_date')

        new_movie = MovieRepository.create(api_id, title, poster_path, overview, release_date)
        return {"message": "Película añadida exitosamente", "pelicula": pelicula_schema.dump(new_movie)}, 201

    @staticmethod
    def get_movie_by_api_id(api_id: int):
        movie = MovieRepository.get_by_api_id(api_id)
        if not movie:
            return {"error": "Película no encontrada"}, 404
        return {"pelicula": pelicula_schema.dump(movie)}, 200

    @staticmethod
    def update_movie(api_id: int, data: dict):
        movie = MovieRepository.get_by_api_id(api_id)
        if not movie:
            return {"error": "Película no encontrada"}, 404

        if not isinstance(data, dict):
            return {"error": "El cuerpo de la solicitud debe ser un objeto JSON"}, 400

        title = data.get('title')
        poster_path = data.get('poster_path')
        overview = data.get('overview')
        release_date = data.get('release_date')

        if title is not None and not str(title).strip():
            return {"error": "El campo title no puede estar vacío"}, 400

        if all(value is None for value in (title, poster_path, overview, release_date)):
            return {"error": "No se enviaron campos para actualizar"}, 400

        updated_movie = MovieRepository.update(
            movie,
            title=title,
            poster_path=poster_path,
            overview=overview,
            release_date=release_date
        )
        return {"message": "Película actualizada exitosamente", "pelicula": pelicula_schema.dump(updated_movie)}, 200

    @staticmethod
    def delete_movie(api_id: int):
        movie = MovieRepository.get_by_api_id(api_id)
        if not movie:
            return {"error": "Película no encontrada"}, 404

        MovieRepository.delete(movie)
        return {"message": "Película eliminada exitosamente"}, 200
