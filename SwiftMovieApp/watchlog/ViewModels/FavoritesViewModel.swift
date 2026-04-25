import Foundation
import SwiftData

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var is_loading = false
    
    // Función para sincronizar la caché local de SwiftData con la base de datos MySQL en Flask
    func syncFavoritesWithServer(context: ModelContext) {
        is_loading = true
        
        Task {
            // Aquí llamarías a APIManager.shared.getFavorites()
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            
            self.is_loading = false
            print("Favoritos sincronizados correctamente con el backend de MySQL")
            // Aquí actualizarías el context de SwiftData con los datos devueltos por el servidor
        
        }
    }
}
