import IngressoDomain

public final class MockMovieRepository: MovieRepositoryProtocol, @unchecked Sendable {
    public var result: Result<[IngressoMovie], Error> = .success([])

    public init() {}

    public func fetchComingSoonMovies() async throws -> [IngressoMovie] {
        try result.get()
    }
}
