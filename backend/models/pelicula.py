from database import db, ma

class Pelicula(db.Model):
    __tablename__ = 'Peliculas'

    id = db.Column('id_pelicula', db.Integer, primary_key=True)
    title = db.Column('titulo', db.String(255), nullable=False)
    overview = db.Column('descripcion', db.Text)
    poster_path = db.Column(db.String(255))
    api_id = db.Column(db.Integer, unique=True, nullable=False)
    release_date = db.Column('fecha_estreno', db.Date)
    fecha_creacion = db.Column(db.DateTime, server_default=db.func.current_timestamp())

    favoritos = db.relationship('Favorito', back_populates='pelicula', cascade='all, delete-orphan')

    def __repr__(self):
        return f"<Pelicula {self.title}>"
