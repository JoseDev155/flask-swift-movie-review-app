import datetime
from database import db, ma

class RefreshToken(db.Model):
    __tablename__ = 'Refresh_Token'

    id = db.Column('id_token', db.Integer, primary_key=True)
    token = db.Column(db.String(500), unique=True, nullable=False)
    fecha_expiracion = db.Column(db.DateTime, nullable=False, default=lambda: datetime.datetime.utcnow() + datetime.timedelta(days=30))
    fecha_creacion = db.Column(db.DateTime, server_default=db.func.current_timestamp())
    usuario_id = db.Column(db.Integer, db.ForeignKey('Usuarios.id_usuario', ondelete='CASCADE'), nullable=True)
    revoked = db.Column(db.Boolean, default=False)

    usuario = db.relationship('Usuario', back_populates='refresh_tokens')
