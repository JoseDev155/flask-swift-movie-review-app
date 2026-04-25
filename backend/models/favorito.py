from database import db, ma
from marshmallow import fields
from sqlalchemy import UniqueConstraint

class Favorito(db.Model):
    __tablename__ = 'Favoritos'

    id = db.Column('id_favorito', db.Integer, primary_key=True)
    fecha_agregado = db.Column(db.DateTime, server_default=db.func.current_timestamp())
    usuario_id = db.Column(db.Integer, db.ForeignKey('Usuarios.id_usuario', ondelete='CASCADE'), nullable=True)
    pelicula_id = db.Column(db.Integer, db.ForeignKey('Peliculas.id_pelicula', ondelete='CASCADE'), nullable=True)

    __table_args__ = (
        UniqueConstraint('usuario_id', 'pelicula_id', name='uix_usuario_pelicula'),
    )

    usuario = db.relationship('Usuario', back_populates='favoritos')
    pelicula = db.relationship('Pelicula', back_populates='favoritos')
