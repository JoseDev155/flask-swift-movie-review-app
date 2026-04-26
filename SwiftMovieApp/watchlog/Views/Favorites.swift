import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    // Consultamos la base de datos local usando SwiftData (Tabla 4)
    @Query(sort: \FavoritoLocal.fecha_agregado, order: .reverse) private var favoritos: [FavoritoLocal]
    @StateObject private var viewModel = FavoritesViewModel()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if favoritos.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No tienes películas favoritas guardadas")
                            .foregroundColor(.gray)
                            .font(.headline)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(favoritos) { fav in
                                if let pelicula = fav.pelicula {
                                    NavigationLink(destination: MovieDetailView(
                                        movieTitle: pelicula.titulo,
                                        movieId: pelicula.id_pelicula,
                                        posterUrl: pelicula.poster_path,
                                        quality: pelicula.calidad
                                    )) {
                                        FavoriteCard(pelicula: pelicula)
                                    }
                                }
                            }
                        }
                        .padding(10)
                    }
                }
            }
            .navigationTitle("Mis Favoritos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.syncFavoritesWithServer(context: modelContext)
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

// Componente visual para la tarjeta de película favorita
struct FavoriteCard: View {
    let pelicula: PeliculaLocal
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(2/3, contentMode: .fit)
                .overlay(
                    Text(pelicula.titulo)
                        .font(.caption)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                )
            
            Text(pelicula.calidad)
                .font(.system(size: 8, weight: .bold))
                .padding(4)
                .background(Color.blue)
                .foregroundColor(.white)
                .rotationEffect(.degrees(45))
                .offset(x: 10, y: -5)
        }
        .clipped()
    }
}
