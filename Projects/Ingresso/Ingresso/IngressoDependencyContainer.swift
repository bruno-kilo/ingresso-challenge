import Foundation
import SwiftData
import IngressoDomain
import IngressoData
import IngressoInfrastructure
import IngressoPresentation

@MainActor
struct IngressoDependencyContainer {
    private let infrastructureFactory = IngressoInfrastructureFactory()
    private let dataFactory = IngressoDataFactory()
    private let presentationFactory = IngressoPresentationFactory()

    private let httpClient: HTTPClientProtocol
    private let movieRepository: MovieRepositoryProtocol
    private let favoritesRepository: FavoritesRepositoryProtocol
    private let movieCacheRepository: MovieCacheRepositoryProtocol
    private let sortStrategy: MovieSortStrategyProtocol

    init(modelContainer: ModelContainer) {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(
            memoryCapacity: 20 * 1024 * 1024,
            diskCapacity: 50 * 1024 * 1024
        )
        configuration.requestCachePolicy = .returnCacheDataElseLoad

        self.httpClient = infrastructureFactory.makeClient(
            baseURL: URL(string: "https://api-content.ingresso.com"),
            configuration: configuration
        )
        self.movieRepository = dataFactory.makeRemoteMovieRepository(client: httpClient)
        self.favoritesRepository = dataFactory.makeFavoritesRepository(modelContainer: modelContainer)
        self.movieCacheRepository = dataFactory.makeMovieCacheRepository(modelContainer: modelContainer)
        self.sortStrategy = dataFactory.makePremiereDateSortStrategy()
    }

    func makeMovieListViewModel() -> MovieListViewModel {
        presentationFactory.makeMovieListViewModel(
            fetchMoviesUseCase: dataFactory.makeFetchMoviesUseCase(
                repository: movieRepository,
                cache: movieCacheRepository,
                sortStrategy: sortStrategy
            ),
            searchMoviesUseCase: dataFactory.makeSearchMoviesUseCase()
        )
    }

    func makeMovieDetailViewModel(movie: IngressoMovie) -> MovieDetailViewModel {
        presentationFactory.makeMovieDetailViewModel(movie: movie)
    }

    func makeFavoritesViewModel() -> FavoritesViewModel {
        presentationFactory.makeFavoritesViewModel(repository: favoritesRepository)
    }

    func makeSettingsViewModel() -> SettingsViewModel {
        presentationFactory.makeSettingsViewModel(cacheRepository: movieCacheRepository)
    }
}
