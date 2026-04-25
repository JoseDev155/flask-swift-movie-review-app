from database import db, ma

class Pelicula(db.Model):
    __tablename__ = 'Peliculas'

    id = db.Column(db.Integer, primary_key=True)
    api_id = db.Column(db.Integer, unique=True, nullable=False)
    title = db.Column(db.String(255), nullable=False)
    poster_path = db.Column(db.String(255))
    overview = db.Column(db.Text)
    release_date = db.Column(db.String(50))

    favoritos = db.relationship('Favorito', back_populates='pelicula', cascade='all, delete-orphan')

    def __repr__(self):
        return f"<Pelicula {self.title}>"
