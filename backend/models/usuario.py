from database import db, ma

class Usuario(db.Model):
    __tablename__ = 'Usuarios'

    id = db.Column('id_usuario', db.Integer, primary_key=True)
    username = db.Column('nombre', db.String(100), nullable=False)
    email = db.Column(db.String(150), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    fecha_creacion = db.Column(db.DateTime, server_default=db.func.current_timestamp())
    fecha_actualizacion = db.Column(db.DateTime, server_default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    favoritos = db.relationship('Favorito', back_populates='usuario', cascade='all, delete-orphan')
    refresh_tokens = db.relationship('RefreshToken', back_populates='usuario', cascade='all, delete-orphan')

    def __repr__(self):
        return f"<Usuario {self.username}>"
