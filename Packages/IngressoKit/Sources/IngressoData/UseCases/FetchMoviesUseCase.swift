import OSLog
import IngressoDomain

struct FetchMoviesUseCase: FetchMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    private let cache: MovieCacheRepositoryProtocol?
    private let sortStrategy: MovieSortStrategyProtocol
    private let logger = Logger(subsystem: "com.brunosantos.Ingresso", category: "FetchMovies")

    init(
        repository: MovieRepositoryProtocol,
        cache: MovieCacheRepositoryProtocol? = nil,
        sortStrategy: MovieSortStrategyProtocol
    ) {
        self.repository = repository
        self.cache = cache
        self.sortStrategy = sortStrategy
    }

    func execute() async throws -> [IngressoMovie] {
        do {
            let movies = try await repository.fetchComingSoonMovies()
            let sorted = sortStrategy.sort(movies)
            logger.info("✓ \(sorted.count) filmes carregados da API")
            try? await cache?.saveMovies(sorted)
            return sorted
        } catch {
            if let cached = try? await cache?.loadCachedMovies(), !cached.isEmpty {
                logger.warning("⚠ API indisponível, usando \(cached.count) filmes do cache")
                return cached
            }
            logger.error("✗ Falha ao buscar filmes: \(error.localizedDescription)")
            throw error
        }
    }
}
