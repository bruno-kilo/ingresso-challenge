import Foundation
import SwiftData
import IngressoDomain
import IngressoData
import IngressoInfrastructure
import IngressoPresentation

@MainActor
struct IngressoDependencyContainer: ViewModelFactoryProtocol {
    private let httpClient: IngressoHTTPClient
    private let movieRepository: RemoteMovieRepository
    private let favoritesRepository: SwiftDataFavoritesRepository
    private let movieCacheRepository: SwiftDataMovieCacheRepository

    init(modelContainer: ModelContainer) {
        let baseURL = URL(string: "https://api-content.ingresso.com")!
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(
            memoryCapacity: 20 * 1024 * 1024,
            diskCapacity: 50 * 1024 * 1024
        )
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        self.httpClient = IngressoHTTPClient(baseURL: baseURL, configuration: configuration)
        self.movieRepository = RemoteMovieRepository(client: httpClient)
        self.favoritesRepository = SwiftDataFavoritesRepository(modelContainer: modelContainer)
        self.movieCacheRepository = SwiftDataMovieCacheRepository(modelContainer: modelContainer)
    }

    func makeMovieListViewModel() -> MovieListViewModel {
        MovieListViewModel(
            fetchMoviesUseCase: FetchMoviesUseCase(repository: movieRepository, cache: movieCacheRepository),
            searchMoviesUseCase: SearchMoviesUseCase()
        )
    }

    func makeMovieDetailViewModel(movie: IngressoMovie) -> MovieDetailViewModel {
        MovieDetailViewModel(movie: movie)
    }

    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(repository: favoritesRepository)
    }

    func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel(cacheRepository: movieCacheRepository)
    }
}
