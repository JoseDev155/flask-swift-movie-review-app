from .usuario import Usuario
from .pelicula import Pelicula
from .favorito import Favorito
from .refresh_token import RefreshToken

# Importar schemas desde el archivo centralizado para evitar errores de inicialización de SqlAlchemy
from .schemas import (
    UsuarioSchema, usuario_schema, usuarios_schema,
    PeliculaSchema, pelicula_schema, peliculas_schema,
    FavoritoSchema, favorito_schema, favoritos_schema,
    RefreshTokenSchema, refresh_token_schema, refresh_tokens_schema
)
