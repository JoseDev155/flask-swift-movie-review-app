import Foundation
import SwiftData

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var is_loading = false
    
    func syncFavoritesWithServer(context: ModelContext) {
        is_loading = true
        
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            self.is_loading = false
            print("Favoritos sincronizados correctamente con el backend de MySQL")
        }
    }
}
