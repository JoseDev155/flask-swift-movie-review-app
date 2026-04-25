from repositories import FavoriteRepository, UserRepository, MovieRepository
from models import favoritos_schema, favorito_schema
from services import MovieService

class FavoriteService:
    @staticmethod
    def add_favorite(user_id: int, data: dict):
        pelicula_id = data.get('pelicula_id') or data.get('api_id')
        pelicula_data = data.get('pelicula') or data.get('movie')

        if not pelicula_id:
            return {"error": "Falta el ID de la película (pelicula_id)"}, 400

        try:
            pelicula_id = int(pelicula_id)
        except (TypeError, ValueError):
            return {"error": "El campo pelicula_id debe ser un entero"}, 400

        # Validaciones de integridad
        user = UserRepository.get_by_id(user_id)
        if not user:
            return {"error": "Usuario no encontrado"}, 404

        movie, error_response, status = MovieService.ensure_movie_cached(pelicula_id, pelicula_data)
        if error_response:
            return error_response, status

        existing = FavoriteRepository.get_by_user_and_movie(user.id, movie.id)
        if existing:
            return {"error": "La película ya está en favoritos"}, 400

        new_favorite = FavoriteRepository.add(user.id, movie.id)
        return {"message": "Película añadida a favoritos", "favorito": favorito_schema.dump(new_favorite)}, 201

    @staticmethod
    def remove_favorite(user_id: int, api_id: int):
        user = UserRepository.get_by_id(user_id)
        movie = MovieRepository.get_by_api_id(api_id)

        if not user or not movie:
            return {"error": "Usuario o película no encontrados"}, 404

        favorite = FavoriteRepository.get_by_user_and_movie(user.id, movie.id)
        if not favorite:
            return {"error": "El favorito no existe"}, 404

        FavoriteRepository.remove(favorite)
        return {"message": "Película removida de favoritos"}, 200

    @staticmethod
    def get_user_favorites(user_id: int):
        user = UserRepository.get_by_id(user_id)
        if not user:
            return {"error": "Usuario no encontrado"}, 404

        favorites = FavoriteRepository.get_all_by_user(user.id)
        return {"favoritos": favoritos_schema.dump(favorites)}, 200
