from repositories import MovieRepository
from models import pelicula_schema, peliculas_schema
from utils import fetch_movie_details, fetch_movies_page

class MovieService:
    @staticmethod
    def get_all_movies():
        movies = MovieRepository.get_all()
        return {"peliculas": peliculas_schema.dump(movies)}, 200

    @staticmethod
    def _cache_movie(movie_data: dict):
        api_id = (movie_data.get('id') or 0)
        if not api_id:
            return None

        movie = MovieRepository.get_by_api_id(int(api_id))
        if movie:
            return movie

        title = movie_data.get('title') or movie_data.get('name')
        if not title:
            return None

        return MovieRepository.create(
            int(api_id),
            title,
            poster_path=movie_data.get('poster_path'),
            overview=movie_data.get('overview'),
            release_date=movie_data.get('release_date')
        )

    @staticmethod
    def _fetch_catalog(path: str, page: int = 1, search_query: str = None):
        payload, error_response, status = fetch_movies_page(path, page=page, search_query=search_query)
        if error_response:
            return error_response, status

        results = payload.get('results') if isinstance(payload, dict) else None
        if isinstance(results, list):
            for movie_data in results:
                if isinstance(movie_data, dict):
                    MovieService._cache_movie(movie_data)

        return payload, 200

    @staticmethod
    def get_popular_movies(page: int = 1):
        return MovieService._fetch_catalog('/movie/popular', page=page)

    @staticmethod
    def get_upcoming_movies(page: int = 1):
        return MovieService._fetch_catalog('/movie/upcoming', page=page)

    @staticmethod
    def search_movies(search_query: str, page: int = 1):
        if not search_query or not str(search_query).strip():
            return {"error": "Falta el término de búsqueda (query)"}, 400

        return MovieService._fetch_catalog('/search/movie', page=page, search_query=search_query.strip())

    @staticmethod
    def ensure_movie_cached(api_id: int, movie_data: dict = None):
        movie = MovieRepository.get_by_api_id(api_id)
        if movie:
            return movie, None, 200

        if movie_data is None:
            movie_data, error_response, status = fetch_movie_details(api_id)
            if error_response:
                return None, error_response, status

        title = movie_data.get('title') or movie_data.get('name')
        if not title:
            return None, {"error": "La película no incluye un título válido"}, 400

        poster_path = movie_data.get('poster_path')
        overview = movie_data.get('overview')
        release_date = movie_data.get('release_date')

        movie = MovieRepository.create(
            api_id,
            title,
            poster_path=poster_path,
            overview=overview,
            release_date=release_date
        )
        return movie, None, 201

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
        if movie:
            return {"pelicula": pelicula_schema.dump(movie)}, 200

        payload, error_response, status = fetch_movie_details(api_id)
        if error_response:
            return error_response, status

        movie, error_response, status = MovieService.ensure_movie_cached(api_id, payload)
        if error_response:
            return error_response, status

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

    @staticmethod
    def format_swift_movies(payload):
        # Transforma la respuesta de TMDb al esquema MovieResponse esperado por Swift
        results = payload.get('results', []) if isinstance(payload, dict) else []
        swift_movies = []
        for movie_data in results:
            if not isinstance(movie_data, dict):
                continue
            poster_path = movie_data.get('poster_path')
            poster_url = f"https://image.tmdb.org/t/p/w500{poster_path}" if poster_path else ""
            swift_movies.append({
                "id": str(movie_data.get('id', '')),
                "title": movie_data.get('title') or movie_data.get('name') or "",
                "poster_url": poster_url,
                "quality": "HD" # Valor por defecto ya que TMDb no provee calidad
            })
        return swift_movies

