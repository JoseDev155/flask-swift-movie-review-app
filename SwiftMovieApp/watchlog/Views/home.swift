struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    // Header
                    HStack {
                        Image(systemName: "line.horizontal.3").foregroundColor(.white)
                        Spacer()
                        Text("MOVIEPLAY").font(.headline).foregroundColor(.white)
                        Spacer()
                        Image(systemName: "magnifyingglass").foregroundColor(.white)
                        NavigationLink(destination: FavoritesView()) {
                            Image(systemName: "heart.fill").foregroundColor(.red)
                        }
                    }
                    .padding()
                    
                    // Categorías
                    HStack(spacing: 20) {
                        Button(action: { viewModel.selectCategory(.peliculas) }) {
                            Text("PELICULAS").underline(viewModel.sel_category == .peliculas)
                        }
                        Button(action: { viewModel.selectCategory(.series) }) {
                            Text("SERIES").underline(viewModel.sel_category == .series)
                        }
                        Button(action: { viewModel.selectCategory(.animes) }) {
                            Text("ANIMES").underline(viewModel.sel_category == .animes)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    
                    ScrollView {
                        if viewModel.is_loading {
                            Spacer().frame(height: 50)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                            Spacer()
                        } else {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(viewModel.movies) { movie in
                                    NavigationLink(destination: MovieDetailView(
                                        movie_title: movie.title,
                                        movie_id: movie.id.uuidString,
                                        poster_url: movie.poster_url,
                                        quality: movie.quality
                                    )) {
                                        MovieCard(movie: movie)
                                    }
                                }
                            }
                            .padding(10)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct MovieCard: View {
    let movie: MovieItem

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(2/3, contentMode: .fit)
                .overlay(
                    Text(movie.title)
                        .font(.caption)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                )
            
            // Etiqueta HD / CAM
            Text(movie.quality)
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