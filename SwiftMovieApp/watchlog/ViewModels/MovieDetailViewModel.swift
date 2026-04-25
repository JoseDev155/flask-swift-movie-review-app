import Foundation
import SwiftData

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var is_fav: Bool = false
    @Published var is_loading: Bool = false
    
    // Comprueba si la película ya existe en la base de datos local (SwiftData)
    func checkFavoriteStatus(movie_id: String, context: ModelContext) {
        let descriptor = FetchDescriptor<FavoritoLocal>(predicate: #Predicate { $0.pelicula_id == movie_id })
        if let count = try? context.fetchCount(descriptor), count > 0 {
            self.is_fav = true
        } else {
            self.is_fav = false
        }
    }
    
    // Agrega o elimina de favoritos, interactuando con SwiftData y preparando la conexión a MySQL
    func toggleFavorite(movie: PeliculaLocal, context: ModelContext) {
        is_loading = true
        
        Task {
            // Simulamos la llamada a la API (POST /favorites o DELETE /favorites)
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            
            if self.is_fav {
                // Remover de favoritos locales
                let movie_id = movie.id_pelicula
                let descriptor = FetchDescriptor<FavoritoLocal>(predicate: #Predicate { $0.pelicula_id == movie_id })
                if let results = try? context.fetch(descriptor) {
                    for fav in results {
                        context.delete(fav)
                    }
                }
            } else {
                // Añadir a favoritos locales
                let newFav = FavoritoLocal(usuario_id: "usuario_actual", pelicula_id: movie.id_pelicula)
                // Insertamos la película en caché si no existía
                context.insert(movie)
                newFav.pelicula = movie
                context.insert(newFav)
            }
            
            try? context.save()
            self.is_fav.toggle()
            self.is_loading = false
        
        }
    }
}
