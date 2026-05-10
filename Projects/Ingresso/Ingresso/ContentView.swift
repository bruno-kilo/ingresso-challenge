import SwiftUI
import SwiftData
import IngressoInfrastructure
import IngressoPresentation
import IngressoUI

struct ContentView: View {
    @State private var router = IngressoRouter()
    @State private var networkMonitor = NetworkMonitor()
    @State private var favoritesViewModel: FavoritesViewModel
    @State private var movieListViewModel: MovieListViewModel
    @State private var searchViewModel: MovieListViewModel
    @State private var preSaleViewModel: MovieListViewModel
    @State private var settingsViewModel: SettingsViewModel

    init(modelContainer: ModelContainer) {
        let container = IngressoDependencyContainer(modelContainer: modelContainer)
        _movieListViewModel = State(initialValue: container.makeMovieListViewModel())
        _searchViewModel = State(initialValue: container.makeMovieListViewModel())
        _preSaleViewModel = State(initialValue: container.makeMovieListViewModel())
        _favoritesViewModel = State(initialValue: container.makeFavoritesViewModel())
        _settingsViewModel = State(initialValue: container.makeSettingsViewModel())
    }

    var body: some View {
        @Bindable var router = router

        TabView(selection: $router.selectedTab) {
            Tab("Estreias", systemImage: "film", value: IngressoTab.premieres) {
                navigationTab { MovieListScreen(viewModel: movieListViewModel) }
            }

            Tab("Pré-venda", systemImage: "ticket", value: IngressoTab.preSale) {
                navigationTab { PreSaleScreen(viewModel: preSaleViewModel) }
            }

            Tab("Favoritos", systemImage: "heart.fill", value: IngressoTab.favorites) {
                navigationTab { FavoritesScreen(viewModel: favoritesViewModel) }
            }

            Tab("Buscar", systemImage: "magnifyingglass", value: IngressoTab.search, role: .search) {
                navigationTab { SearchScreen(viewModel: searchViewModel) }
            }

            Tab("Sobre", systemImage: "gearshape", value: IngressoTab.settings) {
                navigationTab { SettingsScreen(viewModel: settingsViewModel) }
            }
        }
        .environment(router)
        .environment(networkMonitor)
        .environment(favoritesViewModel)
    }

    private func navigationTab<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        @Bindable var router = router
        return NavigationStack(path: $router.currentPath) {
            content()
                .ingressoNavigation()
        }
        .environment(favoritesViewModel)
    }
}
