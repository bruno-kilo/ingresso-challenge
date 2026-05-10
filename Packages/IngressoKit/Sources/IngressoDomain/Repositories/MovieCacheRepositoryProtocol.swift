public protocol MovieCacheRepositoryProtocol: Sendable {
    func saveMovies(_ movies: [IngressoMovie]) async throws
    func loadCachedMovies() async throws -> [IngressoMovie]
    func clearCache() async throws
}
