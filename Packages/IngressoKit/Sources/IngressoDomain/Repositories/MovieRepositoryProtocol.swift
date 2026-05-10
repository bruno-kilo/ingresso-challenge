public protocol MovieRepositoryProtocol: Sendable {
    func fetchComingSoonMovies() async throws -> [IngressoMovie]
}
