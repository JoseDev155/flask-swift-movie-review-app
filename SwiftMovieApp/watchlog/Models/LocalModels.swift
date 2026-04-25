import Foundation
import SwiftData

// MARK: - Tabla 3: Peliculas (Caché Local)
@Model
final class PeliculaLocal {
    @Attribute(.unique) var id_pelicula: String
    var titulo: String
    var descripcion: String
    var poster_path: String
    var api_id: Int
    var fecha_estreno: String
    var calidad: String // HD, CAM
    var categoria: String // PELICULAS, SERIES, ANIMES
    var fecha_creacion: Date
    
    // Relación con Favoritos
    @Relationship(deleteRule: .cascade, inverse: \FavoritoLocal.pelicula)
    var favorito_info: FavoritoLocal?
    
    init(id_pelicula: String, titulo: String, descripcion: String, poster_path: String, api_id: Int, fecha_estreno: String, calidad: String, categoria: String) {
        self.id_pelicula = id_pelicula
        self.titulo = titulo
        self.descripcion = descripcion
        self.poster_path = poster_path
        self.api_id = api_id
        self.fecha_estreno = fecha_estreno
        self.calidad = calidad
        self.categoria = categoria
        self.fecha_creacion = Date()
    }
}

// MARK: - Tabla 4: Favoritos (Persistencia Local)
@Model
final class FavoritoLocal {
    @Attribute(.unique) var id_favorito: String
    var fecha_agregado: Date
    
    // Referencias guardadas para validación si se rompe la relación
    var usuario_id: String
    var pelicula_id: String
    
    var pelicula: PeliculaLocal?
    
    init(id_favorito: String = UUID().uuidString, usuario_id: String, pelicula_id: String) {
        self.id_favorito = id_favorito
        self.usuario_id = usuario_id
        self.pelicula_id = pelicula_id
        self.fecha_agregado = Date()
    }
}
