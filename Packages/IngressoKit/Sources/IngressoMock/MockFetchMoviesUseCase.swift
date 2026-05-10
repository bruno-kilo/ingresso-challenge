import IngressoDomain

public final class MockFetchMoviesUseCase: FetchMoviesUseCaseProtocol, @unchecked Sendable {
    public var result: Result<[IngressoMovie], Error> = .success([])
    public private(set) var executeCallCount = 0

    public init() {}

    public func execute() async throws -> [IngressoMovie] {
        executeCallCount += 1
        return try result.get()
    }
}
