import SwiftUI
import IngressoPresentation

public struct IngressoUIFactory {
    public init() {}

    @MainActor
    public func makeMovieListScreen(viewModel: MovieListViewModel) -> some View {
        MovieListScreen(viewModel: viewModel)
    }

    @MainActor
    public func makePreSaleScreen(viewModel: MovieListViewModel) -> some View {
        PreSaleScreen(viewModel: viewModel)
    }

    @MainActor
    public func makeSearchScreen(viewModel: MovieListViewModel) -> some View {
        SearchScreen(viewModel: viewModel)
    }

    @MainActor
    public func makeFavoritesScreen(viewModel: FavoritesViewModel) -> some View {
        FavoritesScreen(viewModel: viewModel)
    }

    @MainActor
    public func makeMovieDetailScreen(viewModel: MovieDetailViewModel) -> some View {
        MovieDetailScreen(viewModel: viewModel)
    }

    @MainActor
    public func makeSettingsScreen(viewModel: SettingsViewModel) -> some View {
        SettingsScreen(viewModel: viewModel)
    }
}
