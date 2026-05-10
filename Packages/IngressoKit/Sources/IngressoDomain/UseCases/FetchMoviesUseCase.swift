public protocol FetchMoviesUseCaseProtocol: Sendable {
    func execute() async throws -> [IngressoMovie]
}

public struct FetchMoviesUseCase: FetchMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    private let cache: MovieCacheRepositoryProtocol?
    private let sortStrategy: MovieSortStrategyProtocol

    public init(
        repository: MovieRepositoryProtocol,
        cache: MovieCacheRepositoryProtocol? = nil,
        sortStrategy: MovieSortStrategyProtocol = PremiereDateSortStrategy()
    ) {
        self.repository = repository
        self.cache = cache
        self.sortStrategy = sortStrategy
    }

    public func execute() async throws -> [IngressoMovie] {
        do {
            let movies = try await repository.fetchComingSoonMovies()
            let sorted = sortStrategy.sort(movies)
            try? await cache?.saveMovies(sorted)
            return sorted
        } catch {
            if let cached = try? await cache?.loadCachedMovies(), !cached.isEmpty {
                return cached
            }
            throw error
        }
    }
}
