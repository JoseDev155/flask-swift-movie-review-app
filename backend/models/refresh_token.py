from database import db, ma

class RefreshToken(db.Model):
    __tablename__ = 'Refresh_Token'

    id = db.Column(db.Integer, primary_key=True)
    token = db.Column(db.String(512), unique=True, nullable=False)
    usuario_id = db.Column(db.Integer, db.ForeignKey('Usuarios.id', ondelete='CASCADE'), nullable=False)

    usuario = db.relationship('Usuario', back_populates='refresh_tokens')
