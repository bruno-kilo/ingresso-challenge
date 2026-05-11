import SwiftData
import IngressoDomain
import IngressoInfrastructure

public struct IngressoDataFactory {
    public init() {}
    
    public func makePremiereDateSortStrategy() -> MovieSortStrategyProtocol {
        PremiereDateSortStrategy()
    }
    
    public func makeRemoteMovieRepository(client: HTTPClientProtocol) -> MovieRepositoryProtocol {
        RemoteMovieRepository(client: client)
    }
    
    public func makeFetchMoviesUseCase(
        repository: MovieRepositoryProtocol,
        cache: MovieCacheRepositoryProtocol?,
        sortStrategy: MovieSortStrategyProtocol
    ) -> FetchMoviesUseCaseProtocol {
        FetchMoviesUseCase(
            repository: repository,
            cache: cache,
            sortStrategy: sortStrategy
        )
    }
    
    public func makeSearchMoviesUseCase() -> SearchMoviesUseCaseProtocol {
        SearchMoviesUseCase()
    }
    
    public func makeFavoritesRepository(modelContainer: ModelContainer) -> FavoritesRepositoryProtocol {
        SwiftDataFavoritesRepository(modelContainer: modelContainer)
    }
    
    public func makeMovieCacheRepository(modelContainer: ModelContainer) -> MovieCacheRepositoryProtocol {
        SwiftDataMovieCacheRepository(modelContainer: modelContainer)
    }
}
