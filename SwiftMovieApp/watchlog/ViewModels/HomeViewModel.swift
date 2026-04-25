import Foundation

enum ContentCategory: String, CaseIterable {
    case peliculas = "PELICULAS"
    case series = "SERIES"
    case animes = "ANIMES"
}

struct MovieItem: Identifiable {
    let id = UUID()
    let title: String
    let poster_url: String
    let quality: String // HD, CAM, etc.
}

@MainActor
class HomeViewModel: ObservableObject {
    @Published var sel_category: ContentCategory = .peliculas
    @Published var movies: [MovieItem] = []
    @Published var is_loading = false
    @Published var search_text = ""
    
    init() {
        fetchContent()
    }
    
    // Cambiar categoría y recargar
    func selectCategory(_ category: ContentCategory) {
        self.sel_category = category
        fetchContent()
    }
    
    func fetchContent() {
        self.is_loading = true
        
        Task {
            do {
                let api_movies = try await APIManager.shared.fetchMovies(category: self.sel_category.rawValue)
                
                self.movies = api_movies.map { MovieItem(title: $0.title, poster_url: $0.poster_url, quality: $0.quality) }
                self.is_loading = false
            
            } catch {
                
                self.is_loading = false
                print("Error al cargar contenido: \(error.localizedDescription)")
            
            }
        }
    }
    
    func openMenu() {
        print("Abriendo menú lateral...")
    }
    
    func performSearch() {
        print("Buscando: \(search_text)")
    }
}