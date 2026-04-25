from database import db, ma
from marshmallow import fields
from sqlalchemy import UniqueConstraint

class Favorito(db.Model):
    __tablename__ = 'Favoritos'

    id = db.Column(db.Integer, primary_key=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey('Usuarios.id', ondelete='CASCADE'), nullable=False)
    pelicula_id = db.Column(db.Integer, db.ForeignKey('Peliculas.id', ondelete='CASCADE'), nullable=False)

    __table_args__ = (
        UniqueConstraint('usuario_id', 'pelicula_id', name='uix_usuario_pelicula'),
    )

    usuario = db.relationship('Usuario', back_populates='favoritos')
    pelicula = db.relationship('Pelicula', back_populates='favoritos')
