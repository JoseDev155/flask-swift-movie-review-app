from database import ma
from marshmallow import fields
from .usuario import Usuario
from .pelicula import Pelicula
from .favorito import Favorito
from .refresh_token import RefreshToken

class UsuarioSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Usuario
        load_instance = True
        exclude = ("password_hash",)

class PeliculaSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Pelicula
        load_instance = True

class FavoritoSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Favorito
        load_instance = True
        include_fk = True

    pelicula = fields.Nested('PeliculaSchema')

class RefreshTokenSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = RefreshToken
        load_instance = True
        include_fk = True

# Instances
usuario_schema = UsuarioSchema()
usuarios_schema = UsuarioSchema(many=True)

pelicula_schema = PeliculaSchema()
peliculas_schema = PeliculaSchema(many=True)

favorito_schema = FavoritoSchema()
favoritos_schema = FavoritoSchema(many=True)

refresh_token_schema = RefreshTokenSchema()
refresh_tokens_schema = RefreshTokenSchema(many=True)
