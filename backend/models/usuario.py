from database import db, ma

class Usuario(db.Model):
    __tablename__ = 'Usuarios'

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)

    favoritos = db.relationship('Favorito', back_populates='usuario', cascade='all, delete-orphan')
    refresh_tokens = db.relationship('RefreshToken', back_populates='usuario', cascade='all, delete-orphan')

    def __repr__(self):
        return f"<Usuario {self.username}>"
