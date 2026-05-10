import IngressoDomain

public final class MockSearchMoviesUseCase: SearchMoviesUseCaseProtocol, @unchecked Sendable {
    public var result: [IngressoMovie] = []

    public init() {}

    public func execute(query: String, in movies: [IngressoMovie]) -> [IngressoMovie] {
        result
    }
}
