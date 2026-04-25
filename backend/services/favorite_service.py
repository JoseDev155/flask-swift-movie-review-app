from repositories import FavoriteRepository, UserRepository, MovieRepository
from models import favoritos_schema, favorito_schema

class FavoriteService:
    @staticmethod
    def add_favorite(user_id: int, data: dict):
        pelicula_id = data.get('pelicula_id')

        if not pelicula_id:
            return {"error": "Falta el ID de la película (pelicula_id)"}, 400

        # Validaciones de integridad
        user = UserRepository.get_by_id(user_id)
        if not user:
            return {"error": "Usuario no encontrado"}, 404

        movie = MovieRepository.get_by_api_id(pelicula_id) # Ojo, asumiendo que envían api_id, o si envían ID interno hay que ajustar. Si es ID interno, hay que buscar por id normal. Vamos a asumir que envían el ID interno de la BD. Si envían api_id, se debería usar get_by_api_id o crear la película antes.
        # Vamos a requerir el ID interno de la BD para la tabla Favoritos
        
        # En caso de que se pase el ID interno de Peliculas:
        # movie = MovieRepository.get_by_id(pelicula_id) - faltaría ese método.
        # Asumamos por consistencia de la aplicación que se buscará y vinculará usando el api_id pero guardando el internal_id.
        movie = MovieRepository.get_by_api_id(pelicula_id)
        if not movie:
            return {"error": f"Película con api_id {pelicula_id} no existe en la base de datos interna. Debe crearla primero."}, 404

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
