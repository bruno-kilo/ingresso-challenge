import IngressoDomain

public struct IngressoPresentationFactory {
    public init() {}

    @MainActor
    public func makeMovieListViewModel(
        fetchMoviesUseCase: FetchMoviesUseCaseProtocol,
        searchMoviesUseCase: SearchMoviesUseCaseProtocol
    ) -> MovieListViewModel {
        MovieListViewModel(
            fetchMoviesUseCase: fetchMoviesUseCase,
            searchMoviesUseCase: searchMoviesUseCase
        )
    }

    @MainActor
    public func makeMovieDetailViewModel(movie: IngressoMovie) -> MovieDetailViewModel {
        MovieDetailViewModel(movie: movie)
    }

    @MainActor
    public func makeFavoritesViewModel(repository: FavoritesRepositoryProtocol) -> FavoritesViewModel {
        FavoritesViewModel(repository: repository)
    }

    @MainActor
    public func makeSettingsViewModel(cacheRepository: MovieCacheRepositoryProtocol) -> SettingsViewModel {
        SettingsViewModel(cacheRepository: cacheRepository)
    }

    @MainActor
    public func makeRouter() -> IngressoRouter {
        IngressoRouter()
    }
}
