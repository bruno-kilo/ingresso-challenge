import SwiftUI
import IngressoDomain
import IngressoInfrastructure
import IngressoPresentation
import IngressoMock

public struct FavoritesScreen: View {
    @Bindable var viewModel: FavoritesViewModel
    @Environment(IngressoRouter.self) private var router

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
                            Button {
                                router.navigate(to: .movieDetail(movie))
                            } label: {
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

#Preview {
    @Previewable @State var vm: FavoritesViewModel = {
        let repo = MockFavoritesRepository()
        repo.movies = IngressoFixtures.sampleMovies
        return IngressoPresentationFactory().makeFavoritesViewModel(repository: repo)
    }()

    NavigationStack {
        FavoritesScreen(viewModel: vm)
    }
    .environment(IngressoPresentationFactory().makeRouter())
    .environment(IngressoInfrastructureFactory().makeNetworkMonitor())
    .environment(vm)
}
