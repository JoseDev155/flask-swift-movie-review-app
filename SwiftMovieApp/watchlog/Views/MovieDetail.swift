import SwiftUI
import SwiftData

struct MovieDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = MovieDetailViewModel()
    
    var movieTitle: String
    var movieId: String
    var posterUrl: String
    var quality: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Imagen de Cabecera (Póster)
                ZStack(alignment: .bottomTrailing) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(2/3, contentMode: .fit)
                        .overlay(
                            Text(movieTitle)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                    
                    Text(quality)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .padding()
                }
                
                // Información de la película
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(movieTitle)
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        
                        // Botón de Favoritos
                        Button(action: {
                            // Instanciamos el modelo local para pasarlo a SwiftData
                            let tempMovie = PeliculaLocal(
                                idPelicula: movieId,
                                titulo: movieTitle,
                                descripcion: "Descripción descargada desde TMDB.",
                                posterPath: posterUrl,
                                apiId: 0, // Aquí iría el ID real de TMDB
                                fechaEstreno: "2024-01-01",
                                calidad: quality,
                                categoria: "PELICULAS"
                            )
                            viewModel.toggleFavorite(movie: tempMovie, context: modelContext)
                        }) {
                            if viewModel.isLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .red))
                            } else {
                                Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                    .foregroundColor(viewModel.isFavorite ? .red : .white)
                                    .font(.title)
                            }
                        }
                    }
                    
                    Text("2024 • Acción, Aventura • 2h 15m")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Descripción general")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    Text("Esta es la sinopsis detallada de la película. Aquí se mostrará toda la información proveniente de TMDB a través de tu servidor Flask, tal como especifica la Tabla 3 de tu diccionario de datos.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineSpacing(4)
                }
                .padding()
            }
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            viewModel.checkFavoriteStatus(movieId: movieId, context: modelContext)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
