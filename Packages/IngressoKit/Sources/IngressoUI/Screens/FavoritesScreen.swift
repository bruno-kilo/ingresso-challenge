import SwiftUI
import IngressoDomain
import IngressoPresentation

public struct FavoritesScreen: View {
    @Bindable var viewModel: FavoritesViewModel

    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Group {
            if viewModel.favorites.isEmpty {
                ContentUnavailableView(
                    "Sem favoritos",
                    systemImage: "heart",
                    description: Text("Toque no coração ao abrir um filme para salvá-lo aqui.")
                )
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: IngressoSpacing.md)], spacing: IngressoSpacing.lg) {
                        ForEach(viewModel.favorites) { movie in
                            NavigationLink(value: IngressoRoute.movieDetail(movie)) {
                                MoviePosterCard(movie: movie)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
        }
        .overlay(alignment: .bottom) {
            StatusBanner()
                .animation(.snappy, value: true)
        }
        .navigationTitle("Favoritos")
        .task { await viewModel.loadFavorites() }
    }
}
