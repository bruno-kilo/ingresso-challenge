import IngressoDomain

@MainActor
public protocol ViewModelFactoryProtocol {
    func makeMovieListViewModel() -> MovieListViewModel
    func makeMovieDetailViewModel(movie: IngressoMovie) -> MovieDetailViewModel
    func makeFavoritesViewModel() -> FavoritesViewModel
    func makeSettingsViewModel() -> SettingsViewModel
}
